# Example tcp client. Use it with example tcp server. All code taken from juv test
(import uv)
(import proto)
(import log)

(def client (uv/tcp/new))

(defn l [what] (log/debug :client what))

(defn read-all [conn]
  (var stream "")
  (while true 
    (def chunk (yield))
    (let [[message end] (proto/parse chunk)]
      (set stream (string stream message))
      (when (not (empty? end))
        (do
          (l (string "Received: " stream))
          (break))))))

(uv/enter-loop 
  (def conn (uv/tcp/connect client "0.0.0.0" 8120))
  (yield (:read-start conn))
  (read-all conn)
  (yield (:write conn "Hi man!\n"))
  (yield (:write conn "How are you?"))
  (yield (:write conn proto/end))
  (read-all conn)
  (yield (:read-stop conn))
  (:shutdown conn))
