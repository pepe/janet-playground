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

(defn query-params
  "Parses query string into janet struct. 
   Keys are keywordized"
  [nextmw]
  (def matcher
    |(peg/match
      (peg/compile 
       {:eql "=" :sep "&" :content '(some (if-not (+ :eql :sep) 1))
        :main '(some (* (* ':content :eql ':content) (any :sep)))})
      $))
  (fn [req]
    (let [qs (req :query-string)]
      (unless (empty? qs)
        (-?>> qs
             matcher
             (apply table)
             (u/map-keys keyword)
             (u/map-vals hh/decode)
             (put req :query-params)) )
     (nextmw req))))

