# Example tcp client. Use it with example tcp server.
(use /playground/log)
(import ./proto)

(defn main
  "Main entry point"
  [&]
  (with [client (net/connect "localhost" 8000)]
    (log :client (net/read client 1024))
    (forever
      (def msg (getline "to echo: "))
      (:write client msg)
      (if (get (proto/parse msg) 1) (break))
      (log :client (:read client 1024)))))
