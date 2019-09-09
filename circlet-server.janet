# Example http server. All code taken from https://github.com/bakpakin/littleserver
(import circlet)

(defn success [body]
 {:status 200
   :headers {"Content-Type" "text/html"}
   :body body})

(var counter 0)

(defn html [body]
 (string "<!doctype html><html><body><h1>" body "</h1></body></html>") )

(def home-success (-> "Hello from the Janet's Home" html success))

(defn home-handler [req] home-success) # as static as possible

(defn playground-handler [req]
  (set counter (inc counter))
  (def page (html (string "Hello from the Janet's Playground. For the " counter ". time.")))
  (success page))

(defn not-found [&]
  (def page (html "Not Found."))
  {:status 404
   :headers {"Content-Type" "text/html"}
   :body page})

(def routes
  {"/" home-handler
   "/playground" playground-handler
   :default not-found})

# Now build our server
(circlet/server 
  (-> routes
      circlet/router
      circlet/logger)
  8130)
