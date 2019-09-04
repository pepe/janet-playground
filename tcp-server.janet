# Example tcp server. All code taken from juv test
(import uv)
(import proto)
(import log)

(def host "0.0.0.0")
(def port  8120)

(defn l [& what] (log/debug :server (string ;what)) )

(def server (uv/tcp/new))

(defn handler [&]
  (def client (uv/tcp/new))

  (defn answer [stream]
    (yield (:write client (string "You said:\n " stream)))
    (yield (:write client proto/end)))
  (defn stop [stream]
    (l "received")
    (answer stream)
    (l "answered")
    (:read-stop client)
    (l "finished")
    (break))

  (l "connected")
  (:accept server client)
  (yield (:write client "Hi, I will repeat anything you will say!\n"))
  (yield (:write client proto/end))
  (:read-start client)
  (var stream "") 
  (while true
    (def chunk (yield))
    (let [[message end] (proto/parse chunk)]
      (set stream (string stream message))
      (when (not (empty? end)) (stop stream)))))

(uv/enter-loop
  (l "initialized")
  (:bind server host port)
  (l "started")
  (:listen server handler))


