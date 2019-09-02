# Example tcp client. Use it with example tcp server. All code taken from juv test
(import uv)
(import proto)

(def client (uv/tcp/new))

(def g {:message '(<- (any (+ (range "az") (range "AZ") (set " ,.;:!\n")))) :end "-end" :main '(* :message :end)})

(defn read-all [conn]
 (while true 
    (def chunk (string/trim (yield)))
    (if-let [[message] (peg/match proto/g chunk)]
      (do
        (print message)
        (print "\n")
        (break))
      (print chunk))))

(uv/enter-loop 
  (def conn (uv/tcp/connect client "0.0.0.0" 8120))
  (yield (:read-start conn))
  (read-all conn)
  (yield (:write conn "hi man!\n"))
  (yield (:write conn "How are you?"))
  (yield)
  (read-all conn)
  (yield (:write conn "-end-"))
  (yield (:read-stop conn)))
