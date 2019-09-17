(import circlet)

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
                        (if :path (group (* (constant :path) :capture-path)))
                        (if -1 (group (* (constant :root) (constant -1))) ))))}))

(defn- compile-route [route]
  "Compiles custom grammar for one route"
  (-> (seq [[pt p] :in (peg/match grammar route)]
           (case pt
             :root (tuple '* "/" p)
             :path (tuple '* "/" p) 
             :param (tuple '* "/" ~(group (* (constant ,(keyword p))
                                             (<- (some ,content)))))))
      (array/insert 0 '*)
      (array/push -1)
      splice
      tuple
      peg/compile))

(defn compile-routes [routes]
  "Compiles PEG grammar for all routes"
  (let [res @{}]
    (loop [[route action] :pairs routes] 
        (when (string? route) (put res (compile-route route) action)))
    res))

(defn- extract-args [route-grammar uri]
  "Extracts arguments from peg match"
  (when-let [p (peg/match route-grammar uri)]
    (table ;(flatten p))))

(defn lookup [compiled-routes uri]
  "Looks up uri in routes and returns action and params for the matched route"
  (var matched [])
  (loop [[grammar action] :pairs compiled-routes
         :while (empty? matched)]
    (when-let [args (extract-args grammar uri)] (set matched [action args])))
  matched)

(defn router
  "Creates a router middleware"
  [routes]
  (def compiled-routes (compile-routes routes))
  (fn [req]
    (def uri (req :uri))
    (def [action params] (lookup compiled-routes uri))
    (if action 
      ((circlet/middleware action) (put req :params params))
      ((get routes :not-found) req))))
