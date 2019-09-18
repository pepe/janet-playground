(import tester :prefix "")
(import ../src/utils :as utils)

(deftest "number-suffix"
  (test "1st" (= (utils/number-suffix 1) "st"))
  (test "2nd" (= (utils/number-suffix 1) "st"))
  (test "3rd" (= (utils/number-suffix 1) "st"))
  (test "4th" (= (utils/number-suffix 1) "st"))
  (test "21st" (= (utils/number-suffix 1) "st")))

(deftest "map-keys"
  (test "Maps keys to keyword" 
        (deep= (utils/map-keys keyword {"a" 1 "b" 2}) 
               @{:a 1 :b 2})))

(deftest "map-vals"
  (test "Maps vals to square" 
        (deep= (utils/map-vals (fn [x] (* x x)) {"a" 1 "b" 2}) 
               @{"a" 1 "b" 4})))

(deftest "select-keys"
  (test "Selects keys"
        (deep= (utils/select-keys {:a 1 :b 2} [:a]) @{:a 1}))
  (test "Selects more keys"
        (deep= (utils/select-keys {:a 1 :b 2 :c 3} [:a :c]) @{:a 1 :c 3}))
  (def k {:a 1 :b 2 :c 3})
  (def x [:a :c])
  (test "Selects hygiene"
        (deep= (utils/select-keys k x) @{:a 1 :c 3})))

(deftest "join-if-indexed"
  (test "Joins array"
        (= (utils/join-if-indexed ["a" "bb" "ccc"]) "abbccc"))
  (test "Does nothing for string"
        (= (utils/join-if-indexed "abbccc") "abbccc")))
