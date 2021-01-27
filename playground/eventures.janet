# janet -l ./playground/eventures
(comment (import ./playground/eventures :as e :fresh true))

(defn run-supervised []
  ```
  This is simple example of running server in the fiber and supervise it
  from the parent fiber.
  To test it go to the http://localhost:8OOO, and look at code print out.
  Go to /die path and it will kill the process.
  ```
  (def c (ev/chan))
  (defn handler [stream]
    (fn [stream]
      (def req (:read stream 32))
      (if (string/find "die" req)
        (ev/give-supervisor :dying)
        (ev/give-supervisor :received req))
      (net/close stream)))
  (ev/go
    (coro
      (net/server "localhost" "8000" handler)) nil c)
  (forever
    (match (ev/take c)
      [:received req] (pp req)
      [:ok fiber] (pp "Server is running")
      [:dying] (do (pp "OK. Going down.") (break)))))


(defn pipe-thread []
  ```
  This is simple example of communication with thread running in event loop
  through the `os/pipe` .
  It will print four random bytes from /dev/urandom.
  ```
  (def [i o] (os/pipe))
  (ev/thread
    (coro
      (var res @"")
      (with [f (file/open "/dev/urandom" :r)]
        (file/read f 4 res))
      (ev/write o res)
      (ev/close o)
      (print "done")))
  (pp (ev/read i 4)))

(defn pipe-threads [&opt n]
  ```
  This is simple example of communication with many threads running
  in event loop through the `os/pipe` .
  It will print four random bytes from /dev/urandom by thread.
  ```
  (default n 24)
  (def os @[])
  (loop [_ :range [0 n]]
    (def [i o] (os/pipe))
    (ev/go
      (fiber/new
        (fn []
          (ev/thread
            (coro
              (var res @"")
              (with [f (file/open "/dev/urandom" :r)]
                (file/read f 4 res))
              (ev/write o res)
              (ev/close o)
              (print "done"))))
        :tp)
      (array/push os i)))
  (loop [j :range [0 n]]
    (pp (ev/read (os j) 4))))
