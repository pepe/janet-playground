# Example http server. All code taken from https://github.com/bakpakin/littleserver
(import circlet)

(defn handler [req]
  (def body "<!doctype html><html><body><h1>Hello from the Janet's playground.</h1></body></html>")
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body body} )

(defn not-found [&]
  (def body "<!doctype html><html><body>Not Found.</body></html>")
  {:status 404
   :headers {"Content-Type" "text/html"}
   :body body})

(def routes
  {"/playground" handler
   :default not-found})

# Now build our server
(circlet/server 
  (-> routes
      circlet/router
      circlet/logger)
  8130)
