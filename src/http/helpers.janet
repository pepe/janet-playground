(import ../utils :as u)

(defn response [code body &opt headers]
  (default headers @{})
  (let [headers (merge {"Content-Type" "text/html"} headers)]
    {:status code
     :headers headers
     :body body}))

(defn not-found [body &opt headers]
  "Returns not found response"
  (response 404 body headers))

(defn bad-request [body &opt headers]
  "Returns not found response"
  (response 400 body headers))

(defn not-auth [body &opt headers]
  "Returns not autorized response"
  (response 401 body headers))

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

(defn header [text] 
  "Returns header tag with text"
  (string "<h1>" (u/join-if-indexed text) "</h1>"))

(defn html [body]
  "Returns html document with body"
  (string "<!doctype html><html><body>" (u/join-if-indexed body) "</body></html>"))

(def- escape-chars 
  {"%20" " " "%3C" "<" "%3E" ">" "%23" `#` "%25" "%"
    "%7B" "{" "%7D" "}" "%7C" "|" "%5C" `\` "%5E" "^"
    "%7E" "~" "%5B" "[" "%5D" "]" "%60" "`" "%3B" ";"
    "%2F" "/" "%3F" "?" "%3A" ":" "%40" "@" "%3D" "="
    "%26" "&" "%24" "$"})

(defn- substitutes [patts]
  (peg/compile ['% ['any ['+ ;patts '(<- 1)]]]))

(defn- substitute [patt subst] ~(/ (<- ,patt) ,subst) )

(defn decode
  "Decodes string from query string"
  [s]
  (unless s (break))
  (first 
    (peg/match 
       (substitutes 
         (seq [[patt subst] :pairs escape-chars] 
              (substitute patt subst))) s)))

(defn encode
  "Encodes string from query string"
  [s]
  (unless s (break))
  (first 
    (peg/match
      (substitutes 
        (seq [[subst patt] :pairs escape-chars] 
          (substitute patt subst))) s)))
