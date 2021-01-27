# Example tcp server. All code taken from juv test
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
    (def res (net/read stream 1024))
    (def [message end] (proto/parse res))
    (net/write stream (string "You said: " message))
    (set cont (not end)))
  (l "Closed"))

(l "started")
(net/server host port handler)
