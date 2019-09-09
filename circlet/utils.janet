(defn response [code body headers]
 {:status code
  :headers headers
  :body body})

(defn success [body &opt headers]
  (default headers @{})
  (let [headers (merge {"Content-Type" "text/html"} headers)]
   (response 200 body headers)))

(defn set-cookie 
  "Returns map with cookie set"
  [key val]
 {"Set-Cookie" (string key "=" val)} )

(defn get-cookie
  "Returns cookie from request"
  [req key]
  (get-in req [:cookies key]))
