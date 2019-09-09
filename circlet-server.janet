# Example http server. All code taken from https://github.com/bakpakin/littleserver
(import circlet)
(import utils :as u)
(import circlet/middleware :as cm)
(import circlet/utils :as cu)

(defn html [body] (string "<!doctype html><html><body><h1>" body "</h1></body></html>") )

(def home-success (-> "Hello from the Janet's Home" html cu/success))

(defn home-handler [&] home-success) # as static as possible

(defn playground-handler 
  "Render page for playground page"
  [req]
  (def visits (-> req (cu/get-cookie "visits") (or "0") scan-number inc))
  (def visits-suffix (u/number-suffix visits))
  (def body @"")
  (buffer/format body "Hello from the Janet's Playground. For the %d%s. time in the last minute." visits visits-suffix)
  (cu/success (html body) 
                         (cu/set-cookie "visits" (string visits ";Max-Age=60"))))

(defn not-found 
  "Renders page for unmatched route"
  [&]
  (def page (html "Not Found."))
  (cu/response 404 page))

(def routes
  "these are our routes"
  {"/" home-handler
   "/playground" (cm/cookies-parser playground-handler)
   :default not-found})

# build our server
(circlet/server 
  (-> routes
      circlet/router
      circlet/logger)
  8130)
