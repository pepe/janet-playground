(defn response [code body &opt headers]
  (default headers @{})
  (let [headers (merge {"Content-Type" "text/html"} headers)]
    {:status code
     :headers headers
     :body body}))

(defn not-found [body &opt headers]
  "Returns not found response"
  (response 404 body headers))

(defn success [body &opt headers]
  "Return success response "
  (response 200 body headers))

(defn set-cookie 
  "Returns map with cookie set"
  [key val]
  {"Set-Cookie" (string key "=" val)} )

(defn get-cookie
  "Returns cookie from request by key"
  [req key]
  (get-in req [:cookies key]))

(defn get-header
  "Returns header by key"
  [req header] 
  (get-in req [:headers header]) )

(defn- join-if-indexed [arg]
  "Joins argument to string if it is indexed sequence"
  (if (indexed? arg) (string ;arg) arg))

(defn header [text] 
  "Returns header tag with text"
  (string "<h1>" (join-if-indexed text) "</h1>"))

(defn html [body] 
  "Returns html document with body"
  (string "<!doctype html><html><body>" (join-if-indexed body) "</body></html>"))

