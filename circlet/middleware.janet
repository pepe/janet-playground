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
