# Example tcp client. Use it with example tcp server.
(import ./proto)
(import ./log)

(defn l [what] (log/debug :client what))

(with [client (net/connect "localhost" 8000)]
  (l (net/read client 1024))
  (forever
    (def msg (getline "to echo: "))
    (:write client msg)
    (if (get (proto/parse msg) 1) (break))
    (l (:read client 1024))))
