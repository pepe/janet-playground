(freeze @"Ho") #=> "Ho"
(freeze @["Ho"]) #=> ("Ho")
(freeze @["Ho"]) #=> ("Ho")
(freeze @{"Ho" "Ho"}) #=> {"Ho" "Ho"}

(forever
  (print (os/time))
  (ev/sleep 1))

(def f (fiber/new (fn [] (yield 2) 3)))
(pp (resume f)) # => 2
(resume f)
(pp (fiber/last-value f)) # => 3

(def f (ev/spawn 4))
(ev/sleep 0.0001) # give ev a chance in the REPL, remove in file
(fiber/last-value f) # => 4

(def chan (ev/chan))
(def f (ev/go (coro (yield "world")) nil chan))
(def [sig fib] (ev/take chan))
(pp sig) # => :yield
(pp (fiber/last-value fib)) # => prints world

(seq [v :in (coro
              (yield :hi)
              (yield :bye))]
  v)
# => @[:hi :bye]

(ev/call print 10)
(ev/sleep 0.0001) # give ev a chance in the REPL, remove in file
# => prints 10

(defn worker [m]
  (thread/send m "Hello function")
  (:send m "Hello method"))

(thread/new worker)
(pp (thread/receive)) # => prints Hello function
(pp (thread/receive)) # => prints Hello method

(repeat 3
  (print "HO"))
# => prints
# HO
# HO
# HO

(protect
  (if (> (math/random) 0.42)
    (error "Good luck")
    "Bad luck"))

(def t @{:a 1 :b 2 :c @[1 2 3]})
(def ct (table/clone t))

(put ct :a 3) # => @{:c @[1 2 3] :a 3 :b 2}
(pp t) # => @{:c @[1 2 3] :a 1 :b 2}

(update ct :c array/concat 4) # => @{:c @[1 2 3 4] :a 3 :b 2}
(pp ct) # => @{:c @[1 2 3 4] :a 3 :b 2}
# array under key :c is shared between tables!

(def a @[23 42])
(array/clear a)
(pp a)

(var a false)
(defer (set a 42)
  (set a true)
  (error "Oh no!"))

(pp a)

(os/mkdir "templates")

(peg/find '(:d+) "Battery temperature: 40 °C")

(def f (ev/go (coro "world"))) # coro is great for fast fiber creating
(ev/sleep 0.0001) # give ev a chance in the REPL, remove in file
(fiber/last-value f)

(when-with [f (file/open "nofile.exists")]
  (print "Realy?"))

(keyword/slice "some crazy keyword" 11 -1)

(peg/replace-all '(set "aiou") "e" "The quick brown fox jumps over the lazy dog")

(def b @"")
(xprin b "HOHHO")

(def b @"")
(xprint b "HOHHO")

(def b @"")
(def v (* 1000 (math/random)))
(xprinf b "Value reached level %f" v)

(def b @"")
(def v (* 1000 (math/random)))
(xprintf b "Value reached level %f" v)


(defn walker
  `Simple walker function, that prints non-sequential
   members of the form and walks recursively sequential
   members of the tree`
  [form]
  (if (or (indexed? form) (dictionary? form))
    (do (print "Sequence")
      (walk walker form))
    (print form)))

(walk walker [[[[0 1 3]] 16 7 [3 [3 5]] 3 4] 1 [3 4]])

# Sequence
# Sequence
# Sequence
# 0
# 1
# 3
# 16
# 7
# Sequence
# 3
# Sequence
# 3
# 5
# 3
# 4
# 1
# Sequence
# 3
# 4

