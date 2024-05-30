# Example tcp server.
(use /playground/log)
(import ./proto)

(def host "localhost")
(def port 8000)


(defn handler [stream]
  (log :server "Client connected")
  (net/write stream "Hi, I will repeat anything you will say!\n")
  (forever
    (def res (net/read stream 1024))
    (if res
      (do
        (def [message end] (proto/parse res))
        (net/write stream (string "You said: " message))
        (if end
          (break)
          (log :server "Other side said " message)))
      (break)))
  (log :server "Closed"))

(defn main [&]
  (log :server "Server started")
  (net/server host port handler))
