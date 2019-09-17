# Example http server. All code taken from https://github.com/bakpakin/littleserver
(import circlet)
(import sqlite3 :as sql)
(import json)

(import parsing-router :as pr)
(import utils :as u)
(import sql/utils :as su)
(import http/utils :as hu)

(defn not-found 
  "Renders page for unmatched route"
  [&]
  (hu/not-found (hu/html "Not Found.")))

(defn bad-request
  "Renders page for unmatched route"
  [reason]
  (hu/bad-request (hu/html (string "Bad request " reason))))

(def home-success 
  "Content for home page"
  (-> "Hello from the Janet's Home" hu/header hu/html hu/success))

(defn playground-handler 
  "Renders the playground page"
  [req]
  (let [visits (-> req (hu/get-cookie "visits") (or "0") scan-number inc)
        visits-suffix (u/number-suffix visits)]
    (-> ["Hello from the Janet's Playground. For the "  visits visits-suffix " time in the last minute."]
       hu/header 
       hu/html 
       (hu/success (hu/set-cookie "visits" (string visits ";Max-Age=60"))))))

(defn person-line [record] 
  "Returns line with person's record detail"
  (string "<h2> for " (record "name") " call " (record "phone") "</h2>"))

(defn people-handler 
  "Renders the people page"
  [req]
  (let [accept (hu/get-header req "Accept")
        records (if-let [qp (req :query-params)] 
                  (su/find-records "people"
                                   (->> [:name :phone] 
                                    (u/select-keys qp) 
                                    (u/map-vals hu/decode))) 
                  (su/get-records "people"))]
    (if (= accept "application/json")
      (hu/success (json/encode records) {"Content-Type" "application/json"})
      (->> records
           (map person-line)
           (array/concat @[] (hu/header "People list"))
           hu/html
           hu/success))))

(defn person-handler 
  "Renders the one person page"
  [req]
  (if-let [id (-> req (get-in [:params :id]) scan-number)]
    (let [accept (hu/get-header req "Accept")
          record (su/get-record "people" id)]
      (if record
       (if (= accept "application/json")
         (hu/success (json/encode record) {"Content-Type" "application/json"})
         (do 
           (->> record
                person-line
                (array/concat @[] (hu/header ["Person id: " id]))
                hu/html
                hu/success)))
       (not-found req)))
    (bad-request "ID has bad type, it should be number.")))

(defn bearer-auth
  "Handles authorization by Bearer"
  [nextmw bearer]
  (fn [req]
    (let [authorization (hu/get-header req "Authorization")]
      (if (= authorization (string "Bearer " bearer)) 
        (nextmw req) 
        (hu/not-auth "You are not authorized")))))

(defn query-params
  "Parses query string into janet struct. 
   Keys are keywordized"
  [nextmw]
  (def matcher
    |(peg/match
      (peg/compile 
       {:eql "=" :sep "&" :content '(some (if-not (+ :eql :sep) 1))
        :main '(some (* (* ':content :eql ':content) (any :sep)))})
      $))
  (fn [req]
    (-?>> :query-string
          req 
          matcher
          (apply table)
          (u/map-keys keyword)
          (put req :query-params)
          nextmw)))

(def routes
  "Defines routes"
  {"/" home-success
   "/playground" (-> playground-handler circlet/cookies circlet/logger)
   "/people" (-> people-handler query-params circlet/logger)
   "/people/:id" (-> person-handler circlet/logger)
   "/person/:id" (-> person-handler circlet/logger)
   "/protected-people" (-> people-handler (bearer-auth "abcd") circlet/logger)
   :not-found not-found})

(-> routes pr/router (circlet/server 8130))

(su/close)
