(defn number-suffix 
  "Adds english suffix to order number"
  [num]
  (if (< 10 num 14)
    "th"
    (case (% num 10)
          1 "st"
          2 "nd"
          3 "rd"
          "th")))

(defn map-keys 
  "Returns new table with f applied to dictionary's keys"
  [f d]
  (-> [[k v] :pairs d]
       (seq [(f k) v])
       flatten
       splice
       table))

(defn map-vals
  "Returns new table with f applied to dictionary's values"
  [f d]
  (-> [[k v] :pairs d]
       (seq [k (f v)])
       flatten
       splice
       table))

(defmacro select-keys
  "Returns new struct with only keys from xs selected"
  [d sk]
  ~(->>
     (seq [[k v] :pairs ,d
           :when (or ,;(seq [x :in sk] (tuple '= 'k x)))]
          [k v])
     flatten
     splice
     table))
