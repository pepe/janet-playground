(defn cookies-parser 
  "Parses cookies from request into table under :cookies key"
  [nextmw]
  (fn [req]
    (-> req
      (put :cookies
           (or
             (-?>> [:headers "Cookie"] 
                   (get-in req) 
                   (string/split ";") 
                   (map |(string/split "=" $)) 
                   flatten 
                   (map string/trim) 
                   (apply table))
             {}))
     nextmw)))
