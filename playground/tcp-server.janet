# Example tcp server.
(import ./proto)
(import ./log)

(def host "localhost")
(def port 8000)

(defn l [& what] (log/debug :server (string ;what)))

(defn handler [stream]
  (l "Connection ")
  (net/write stream "Hi, I will repeat anything you will say!\n")
  (var cont true)
  (while cont
    (def res (tracev (net/read stream 1024)))
    (if res
      (do
        (def [message end] (proto/parse res))
        (net/write stream (string "You said: " message))
        (if end
          (set cont false)
          (print "Other side said " message)))
      (set cont false)))
  (l "Closed"))

(defn main [&]
  (l "started")
  (net/server host port handler))
