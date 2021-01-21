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

# (pp (macex1 '(cond-> @{}
#                      (> a 1) (put :a a)
#                      (> b 1) (put :b b)
#                      (> a b) freeze)))

(var a 2)
(var b 1)
(pp (cond-> @{}
            (> a 1) (put :a a)
            (> b 1) (put :b b)
            (> a b) freeze))
# (var res @{})

# (if (> a 1) (set res (put res :a a)))
# (if (> b 1) (set res (put res :b b)))
# (if (> a b) (set res (freeze res)))

