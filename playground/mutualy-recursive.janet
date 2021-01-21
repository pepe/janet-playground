# mutualy recursive functions, taken from gitter @Taobert2
(var a nil)
(var b nil)

(set a (fn [i] (print "a " i) (-> i inc b)))
(set b (fn [i] (print "b " i) (-> i inc a)))

(a 0)
