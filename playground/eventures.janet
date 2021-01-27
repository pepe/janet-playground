(comment (import ./playground/eventures :as e :fresh true))

(defn run-supervised []
  (def c (ev/chan))
  (ev/go
    (coro
      (net/server "localhost" "8888"
                  (fn [stream]
                    (def req (:read stream 32))
                    (if (string/find "die" req)
                      (ev/give-supervisor :dying)
                      (ev/give-supervisor :received req))
                    (net/close stream)))) nil c)
  (forever
    (match (ev/take c)
      [:received req] (pp req)
      [:ok fiber] (pp "Server is running")
      [:dying] (do (pp "OK. Going down.") (break)))))


(defn pipe-thread []
  (def [i o] (os/pipe))
  (ev/thread
    (coro
      (var res @"")
      (with [f (file/open "/dev/urandom" :r)]
        (file/read f 16 res))
      (ev/write o res)
      (ev/close o)
      (print "done")))
  (pp (ev/read i 4)))
