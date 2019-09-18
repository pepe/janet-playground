(import utils :as u)
(import http/helpers :as hh)

(defn bearer-auth
  "Handles authorization by Bearer"
  [nextmw bearer]
  (fn [req]
    (let [authorization (hh/get-header req "Authorization")]
      (if (= authorization (string "Bearer " bearer)) 
        (nextmw req) 
        (hh/not-auth "You are not authorized")))))

(def- query-string-grammar
  (peg/compile 
       {:eql "=" :sep "&" :content '(some (if-not (+ :eql :sep) 1))
        :main '(some (* (* ':content :eql ':content) (any :sep)))}))

(defn- parse-query-string 
  "Parses query string into table. Keywordize keys and decode values"
  [query-string]
  (-?>> query-string
        (peg/match query-string-grammar)
        (apply table)
        (u/map-keys keyword)
        (u/map-vals hh/decode)))

(defn query-params
  "Parses query string into janet struct. 
   Keys are keywordized"
  [nextmw]
  (fn [req]
    (let [query-string (req :query-string)]
      (unless (empty? query-string)
        (-?>> query-string
              parse-query-string
              (put req :query-params)))
     (nextmw req))))

