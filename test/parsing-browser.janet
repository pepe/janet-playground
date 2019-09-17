(import tester :prefix "")
(import ../src/parsing-router :as parsing-router)

(def compiled-routes 
  (parsing-router/compile-routes {"/" :root
                                  "/home/:id" :home}))

(pp (parsing-router/lookup compiled-routes "/home/"))

(deftest "Lookup uri"
  (test "lookup"
        (deep= (parsing-router/lookup compiled-routes "/home/3") 
               '(:home @{:id "3"})))
  (test "lookup root"
        (deep= (parsing-router/lookup compiled-routes "/") 
               '(:root @{})))
  (test "lookup rooty"
        (deep= (parsing-router/lookup compiled-routes "/home/") 
               '(:root @{}))))
