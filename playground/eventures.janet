# janet -l ./playground/eventures
# (import ./playground/eventures :as e :fresh true)

(defn run-supervised []
  ```
  This is simple example of running server in the fiber and supervise it
  from the parent fiber.
  To test it go to the http://localhost:8OOO, and look at code print out.
  Go to /die path and it will kill the process.
  ```
  (def c (ev/chan))
  (defn handler [stream]
    (def req (:read stream 1024))
    (if (string/find "die" req)
      (ev/give-supervisor :dying)
      (ev/give-supervisor :received req))
    (net/close stream))
  (def server (net/listen "localhost" "8000"))
  (def fib
    (ev/go
      (fiber/new
        (fn []
          (ev/give-supervisor :running)
          (forever (handler (net/accept server)))) :tp) nil c))
  (forever
    (match (ev/take c)
      [:received req] (do (print "Received") (pp req))
      [:running] (pp "Server is running")
      [:dying] (do (pp "OK. Going down.") (break))))
  (ev/cancel fib "Called die"))

(defn pipe-thread []
  ```
  This is simple example of communication with thread running in event loop
  through the `os/pipe`.
  It will print four random bytes from /dev/urandom.
  ```
  (def [i o] (os/pipe))
  (ev/do-thread
    (var res @"")
    (with [f (file/open "/dev/urandom" :r)]
      (file/read f 4 res))
    (ev/write o res)
    (ev/close o)
    (print "done"))
  (pp (ev/read i 4)))

(defn pipe-threads [&opt n]
  ```
  This is simple example of communication with many threads running
  in event loop through the `os/pipe` .
  Takes optional number of threads to spin, default is 4. Try 128. About 256
  is limit before there is problem with pipe opening.
  It will print tuple with thread id and four random bytes from /dev/urandom
  by thread.
  ```
  (default n 4)
  (def os @[])
  (def chan (ev/chan n))
  (loop [j :range [0 n]]
    (ev/go
      (fiber/new
        (fn []
          (def [i o] (os/pipe))
          (ev/do-thread
            (var res @"")
            (with [f (file/open "/dev/urandom" :r)]
              (file/read f 4 res))
            (ev/write o (marshal [j res])))
          (ev/give-supervisor :read (unmarshal (ev/read i 32))))
        :tp)
      nil chan))
  (loop [_ :range [0 (* 2 n)]]
    (pp (ev/take chan))))

(defn threads-chan [&opt n]
  ```
  This function is the simple example of the thread-chan in event loop.
  Takes optional number of threads to spin, default is 4.
  It prints the thread working and at the end the value computed.
   ```
  (default n 4)
  (def chan (ev/thread-chan n))
  (loop [j :range [0 n]]
    (ev/thread
      (coro
        (print "Thread #" j " starts")
        (var res 0)
        (repeat (math/pow 10 (min 8 j)) (+= res (math/random)))
        (ev/give chan [j res]))
      nil :n))
  (ev/do-thread
    (loop [_ :range [0 n] :let [t (ev/take chan)]]
      (print "from the thread " (t 0) " I got " (describe (t 1))))))
