# Example http server. 

(import circlet)
(import json)

(import utils :as u)
(import sql/utils :as su)
(import http/router :as r)
(import http/middleware :as mw)
(import http/helpers :as hh)

(defn not-found 
  "Renders page for unmatched route"
  [&]
  (hh/not-found (hh/html "Not Found.")))

(defn bad-request
  "Renders page for unmatched route"
  [reason]
  (hh/bad-request (hh/html (string "Bad request " reason))))

(def home-success 
  "Content for home page"
  (-> "Hello from the Janet's Home" hh/header hh/html hh/success))

(defn playground-handler 
  "Renders the playground page"
  [req]
  (let [visits (-> req (hh/get-cookie "visits") (or "0") scan-number inc)
        visits-suffix (u/number-suffix visits)]
    (-> ["Hello from the Janet's Playground. For the "  visits visits-suffix " time in the last minute."]
       hh/header 
       hh/html 
       (hh/success (hh/set-cookie "visits" (string visits ";Max-Age=60"))))))

(defn person-line [record] 
  "Returns line with person's record detail"
  (string "<h2> for " (record "name") " call " (record "phone") "</h2>"))

(defn people-handler 
  "Renders the people page"
  [req]
  (let [accept (hh/get-header req "Accept")
        records (if-let [qp (req :query-params)] 
                  (su/find-records "people" (u/select-keys qp [:name :phone])) 
                  (su/get-records "people"))]
    (if (= accept "application/json")
      (hh/success (json/encode records) {"Content-Type" "application/json"})
      (->> records
           (map person-line)
           (array/concat @[] (hh/header "People list"))
           hh/html
           hh/success))))

(defn person-handler 
  "Renders the one person page"
  [req]
  (if-let [id (-> req (get-in [:params :id]) scan-number)]
    (let [accept (hh/get-header req "Accept")
          record (su/get-record "people" id)]
      (if record
       (if (= accept "application/json")
         (hh/success (json/encode record) {"Content-Type" "application/json"})
         (do 
           (->> record
                person-line
                (array/concat @[] (hh/header ["Person id: " id]))
                hh/html
                hh/success)))
       (not-found req)))
    (bad-request "ID has bad type, it should be number.")))

(def routes
  "Defines routes"
  {"/" home-success
   "/playground" (-> playground-handler circlet/cookies circlet/logger)
   "/people" (-> people-handler mw/query-params)
   "/people/:id" person-handler
   "/person/:id" person-handler
   "/protected-people" (-> people-handler (mw/bearer-auth "abcd") circlet/logger)
   :not-found not-found})

(-> routes r/router (circlet/server 8130))

(su/close)
