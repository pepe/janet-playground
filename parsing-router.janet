(def content 
  "Characters we consider part of the route"
  '(+ (range "AZ") (range "az") (range "09") (set "-_")))

(def grammar 
  "PEG grammar to match routes with"
  (peg/compile
    {:slash "/" :path ~(some ,content) 
     :param '(* ":" :path) :capture-path '(<- :path)
     :main '(some (* :slash 
                     (+ (if :param (group (* (constant :param) ":" :capture-path)))
                        (if :path (group (* (constant :path) :capture-path))))))}))

(defn- parse-route [route]
  "Creates custom grammar for one route"
  (-> (seq [[pt p] :in (peg/match grammar route)]
           (case pt
             :path (tuple '* "/" p) 
             :param (tuple '* "/" ~(group (* (constant ,(keyword p))
                                             (<- (some ,content)))))))
      (array/insert 0 '*)
      splice
      tuple))

(defn parse-routes [routes]
  (let [res @{}]
    (loop [[route action] :pairs routes] 
        (put res (parse-route route) action))
    res))

(defn perform [routes uri]
  (defn make-args [route-grammar uri]
    (when-let [p (peg/match route-grammar uri)]
      (table ;(flatten p))))

  (loop [[grammar action] :pairs (parse-routes routes)]
    (when-let [args (make-args grammar uri)] (action args) (break))))

(def my-routes
 {#"/" (fn [args] (print "root") (pp args))
  "/home/:id" (fn [args] (print "home") (pp args))
  "/home/:id/action/:action" (fn [args] (print "action") (pp args))})

(perform my-routes "/home/13")
(perform my-routes "/home/13/action/34")
