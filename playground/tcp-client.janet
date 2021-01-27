# Example tcp client. Use it with example tcp server. All code taken from juv test
(import ./proto)
(import ./log)

(defn l [what] (log/debug :client what))

(with [client (net/connect "localhost" 8000)]
  (l (net/read client 1024))
  (net/write client "Hi man!\n")
  (net/write client "How are you?")
  (net/write client proto/end)
  (l (net/read client 1024)))
