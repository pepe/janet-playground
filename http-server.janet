# Example http server. All code taken from https://github.com/bakpakin/littleserver
(import circlet)
(import sqlite3 :as sql)
(import json)

(import utils :as u)
(import sql/utils :as su)
(import http/utils :as hu)

(def home-success 
  "Content for home page"
  (-> "Hello from the Janet's Home" hu/header hu/html hu/success))

(defn playground-handler 
  "Renders the playground page"
  [req]
  (pp req)
  (let [visits (-> req (hu/get-cookie "visits") (or "0") scan-number inc)
        visits-suffix (u/number-suffix visits)]
    (-> ["Hello from the Janet's Playground. For the "  visits visits-suffix " time in the last minute."]
       hu/header 
       hu/html 
       (hu/success (hu/set-cookie "visits" (string visits ";Max-Age=60"))))))

(defn people-handler 
  "Renders the people page"
  [req]
  (let [accept (hu/get-header req "Accept")
        records (su/get-records "people") ]
    (if (= accept "application/json")
      (hu/success (json/encode records) {"Content-Type" "application/json"})
      (do 
        (defn record-line [record] (string "<h2> for " (record "name") " call " (record "phone") "</h2>"))
        (->> records
             (map record-line)
             (array/concat @[] (hu/header "People list"))
             hu/html
             hu/success)))))

(defn bearer-handler
  "Handles authorization by Bearer:"
  [nextmw bearer]
  (fn [req]
    (let [authorization (hu/get-header req "Authorization")]
      (if (= authorization (string "Bearer: " bearer)) 
        (nextmw req) 
        (hu/not-auth "You are not authorized")))))

(defn not-found 
  "Renders page for unmatched route"
  [&]
  (hu/not-found (hu/html "Not Found.")))

(def routes
  "Defines routes"
  {"/" home-success
   "/playground" (-> playground-handler circlet/cookies circlet/logger)
   "/people" (-> people-handler circlet/logger)
   "/protected-people" (-> people-handler (bearer-handler "abcd") circlet/logger)
   :default not-found})

(-> routes circlet/router (circlet/server 8130))

(su/close)
