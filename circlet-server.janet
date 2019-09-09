# Example http server. All code taken from https://github.com/bakpakin/littleserver
(import circlet)
(import utils)

(defn response [code body headers]
 {:status code
  :headers headers
  :body body})

(defn success [body &opt headers]
  (default headers @{})
  (let [headers (merge {"Content-Type" "text/html"} headers)]
   (response 200 body headers)))

(defn html [body] (string "<!doctype html><html><body><h1>" body "</h1></body></html>") )

(def home-success (-> "Hello from the Janet's Home" html success))

(defn home-handler [&] home-success) # as static as possible

(defn set-cookie [key val]
 {"Set-Cookie" (string key "=" val)} )

(defn playground-handler [req]
  (def visits (-> req 
                  (get-in [:cookies "visits"] "0")
                  scan-number
                  inc))
  (def visits-suffix (utils/number-suffix visits))
  (def body @"")
  (buffer/format body "Hello from the Janet's Playground. For the %d%s. time in the last minute." visits visits-suffix)
  (success (html body) (set-cookie "visits" (string visits ";Max-Age=60"))))

(defn not-found [&]
  (def page (html "Not Found."))
  (response 404 page))

(def routes
  {"/" home-handler
   "/playground" playground-handler
   :default not-found})

(defn cookies-parser 
  "Parses cookies from request into table under :cookies key"
  [nextmw]
  (fn [req]
    (def cookies-str (get-in req [:headers "Cookie"]))
    (nextmw 
      (put req :cookies
           (if cookies-str
             (->> cookies-str
                  (string/split ";") 
                  (map |(string/split "=" $))
                  flatten
                  (map string/trim)
                  splice
                  table)
             {})))))

# Now build our server
(circlet/server 
  (-> routes
      circlet/router
      cookies-parser
      circlet/logger)
  8130)
