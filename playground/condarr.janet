(defmacro cond->
  ```
  Threading conditional macro. Takes value to mutate,
  and pairs of condition and operation to which the value,
  is put as first argument. All conditions are tried and
  for truthy the operation is ran.
  Returns mutated value if any condition is truthy.
  ```
  [val & clauses]
  (with-syms [res]
    ~(do
       (var ,res ,val)
       ,;(map
           (fn [[cnd ope]]
             (def ope (if (tuple? ope) ope (tuple ope)))
             (tuple
               'if cnd
               (tuple 'set res
                      (tuple (first ope) res
                             ;(tuple/slice ope 1 -1)))))
           (partition 2 clauses))
       ,res)))

(defmacro cond->>
  ```
  Threading conditional macro. Takes value to mutate,
  and pairs of condition and operation to which the value,
  is put as last argument. All conditions are tried and
  for truthy the operation is ran.
  Returns mutated value if any condition is truthy.
  ```
  [val & clauses]
  (with-syms [res]
    ~(do
       (var ,res ,val)
       ,;(map
           (fn [[cnd ope]]
             (def ope (if (tuple? ope) ope (tuple ope)))
             (tuple
               'if cnd
               (tuple 'set res (tuple ;ope res))))
           (partition 2 clauses))
       ,res)))

# (pp (macex1 '(cond-> @{}
#           (> a 1) (put :a a)
#           (> b 1) (put :b b)
#           (> c 0.5) (merge {:hola "Amigo"})
#           (> a b) freeze)))

(def a 2)
(def b 1)
(math/seedrandom (os/cryptorand 1))
(def c (math/random))
(pp c)
(pp (cond-> @{:a 10}
            (> a 1) (put :a a)
            (> b 1) (put :b b)
            (> c 0.5) (put :hola "Amigo")
            (> a b) freeze))

(pp (cond->> @{:a 10}
             (> a 1) (merge {:a a})
             (> b 1) (merge {:b b})
             (> c 0.5) (merge {:hola "Amigo"})
             (> a b) freeze))
