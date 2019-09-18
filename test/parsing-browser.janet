(import tester :prefix "")
(import ../src/parsing-router :as parsing-router)

(def routes {"/" :root "/home/:id" :home})
(def compiled-routes 
  (parsing-router/compile-routes routes))

(deftest "Lookup uri"
  (test "lookup"
        (deep= (parsing-router/lookup compiled-routes "/home/3") 
               '(:home @{:id "3"})))
  (test "lookup root"
        (deep= (parsing-router/lookup compiled-routes "/") 
               '(:root @{})))
  (test "lookup rooty"
        (empty? (parsing-router/lookup compiled-routes "/home/"))))

(deftest "Router"
  (def router (parsing-router/router routes))
  (test "Router root"
        (= (router @{:uri "/"}) :root))
  (test "Router home"
        (= (router @{:uri "/home/3"}) :home)))
