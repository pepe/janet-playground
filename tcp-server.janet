# Example tcp server. All code taken from juv test
(import uv)

(uv/enter-loop
  (def server (uv/tcp/new))
  (:bind server "0.0.0.0" 8120)
  (print "started!")
  (:listen server 
           (fn [&]
              (print "connected!")
              (def client (uv/tcp/new))
              (:accept server client)
              (yield (:write client "Hi, I will repeat anything you will say!\n"))
              (yield (:write client "exit: I will stop talking with you.\n"))
              (yield (:write client "die: I will stop.\n"))
              (:read-start client)
              (while true
                (def chunk (string/trim (yield)))
                (case chunk
                  "exit"
                  (do
                    (:read-stop client)
                    (print "---done!---")
                    (break))
                  "die"
                  (do 
                    (:read-stop client)
                    (print "---died!---")
                    (os/exit 0))
                  (do
                    (print "Received " chunk)
                    (yield (:write client "You said "))
                    (yield (:write client chunk))
                    (yield (:write client "\n"))))))))


