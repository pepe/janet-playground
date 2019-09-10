(defn cookies
  "Parses cookies from request into table under :cookies key"
  [nextmw]
  (def grammar 
    (peg/compile 
      {:content '(some (if-not (set "=;") 1))
       :eql "=" :sep '(between 1 2 (set "; "))
       :main '(some (* (<- :content) :eql (<- :content) (? :sep)))}))
  (fn [req]
    (-> req
      (put :cookies
           (or
             (-?>> [:headers "Cookie"] 
                   (get-in req) 
                   (peg/match grammar) 
                   (apply table))
             {}))
     nextmw)))
