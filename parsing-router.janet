(def content '(+ (range "AZ") (range "az") (range "09") (set "-_")))
(def grammar {:slash "/" :path ~(some ,content) 
              :main '(some (* :slash (+ (if (* ":" :path) (group (* (constant :param) ":" (<- :path))))
                                        (if :path (group (* (constant :path) (<- :path)))))))})




(defn parse-route [route]
  "Creates custom grammar for one route"
  (tuple 
    ;(array/insert
      (map (fn [part] 
             (case (first part)
                :path (tuple '* "/" (last part)) 
                :param (tuple '* "/" ~(group (* (constant ,(keyword (last part)))
                                                (<- (some ,content))))))) 
           (peg/match grammar route))
      0 '*)))

(defn make-args [route-grammar uri]
  (when-let [p (peg/match route-grammar uri)]
    (table ;(flatten p))))

(defn parse-routes [routes]
  (let [res @{}]
    (loop [[route action] :pairs routes] 
        (put res (parse-route route) action))
    res))

(defn perform [routes uri]
  (let [pr (parse-routes routes)]
    (loop [[grammar action] :pairs pr]
      (when-let [args (make-args grammar uri)] (action args) (break)))))

(def my-routes
 {"/home/:id" (fn [args] (print "home") (pp args))
  "/home/:id/action/:action" (fn [args] (print "action") (pp args))})

(perform my-routes "/home/13")
(perform my-routes "/home/13/action/34")
