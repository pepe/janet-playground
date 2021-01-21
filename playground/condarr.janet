(defmacro cond-> [val & clauses]
  (with-syms [rs]
    ~(do
       (var ,rs ,val)
       ,;(map
           (fn [[cnd ope]]
             (def ope (if (tuple? ope) ope (tuple ope)))
             (tuple
               'if cnd
               (tuple 'set rs (tuple (first ope) rs ;(tuple/slice ope 1 -1)))))
           (partition 2 clauses))
       ,rs)))

(defmacro cond->> [val & clauses]
  (with-syms [rs]
    ~(do
       (var ,rs ,val)
       ,;(map
           (fn [[cnd op]]
             (def op (if (tuple? op) op (tuple op)))
             (tuple
               'if cnd
               (tuple 'set rs (tuple ;op rs))))
           (partition 2 clauses))
       ,rs)))

# (pp (macex1 '(cond-> @{}
#           (> a 1) (put :a a)
#           (> b 1) (put :b b)
#           (> c 0.5) (merge {:hola "Amigo"})
#           (> a b) freeze)))

(var a 2)
(var b 1)
(var c (math/random))
(pp (cond-> @{}
            (> a 1) (put :a a)
            (> b 1) (put :b b)
            (> c 0.5) (put :hola "Amigo")
            (> a b) freeze))

(pp (cond->> @{}
             (> a 1) (merge {:a a})
             (> b 1) (merge {:b b})
             (> c 0.5) (merge {:hola "Amigo"})
             (> a b) freeze))
