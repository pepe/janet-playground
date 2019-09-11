# Example http server. All code taken from https://github.com/bakpakin/littleserver
(import circlet)
(import sqlite3 :as sql)
(import json)

(import utils :as u)
(import circlet/utils :as cu)

(def db (sql/open "people.db"))

(defn join-if-array [arg]
 (if (array? arg) (string ;arg) arg))

(defn header [text] 
  (let [text (join-if-array text)] 
    (string "<h1>" text "</h1>")))

(defn html [body] 
  (let [body (join-if-array body)]
    (string "<!doctype html><html><body>" body "</body></html>")) )

(defn get-records [table]
  (sql/eval db (string `SELECT * FROM ` table `;`)))

(def home-success 
  "Content for home page"
  (-> "Hello from the Janet's Home" header html cu/success))

(defn playground-handler 
  "Renders the playground page"
  [req]
  (def visits (-> req (cu/get-cookie "visits") (or "0") scan-number inc))
  (def visits-suffix (u/number-suffix visits))
  (-> ["Hello from the Janet's Playground. For the "  visits visits-suffix " time in the last minute."]
      header 
      html 
      (cu/success (cu/set-cookie "visits" (string visits ";Max-Age=60")))))

(defn people-handler 
  "Renders the people page"
  [req]
  (def accept (get-in req [:headers "Accept"]))
  (def records (get-records "people"))
  (if (= accept "application/json")
    (cu/success (json/encode records) {"Content-Type" "application/json"})
    (do 
     (defn record-line [record] (string "<h2> for " (record "name") " call " (record "phone") "</h2>"))
     (->> records
          (map record-line)
          (array/concat @[] (header "People list"))
          html
          cu/success))))

(defn not-found 
  "Renders page for unmatched route"
  [&]
  (def page (html "Not Found."))
  (cu/response 404 page))

(def routes
  "these are our routes"
  {"/" (fn [&] home-success)
   "/playground" (-> playground-handler circlet/cookies circlet/logger)
   "/people" (-> people-handler circlet/logger)
   :default not-found})

(circlet/server (circlet/router routes) 8130)
(sql/close db)
