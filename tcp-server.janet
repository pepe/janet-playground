# Example tcp server. All code taken from juv test
(import uv)
(import proto)

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
              (yield (:write client "-end-"))
              (:read-start client)
              (while true
                (def chunk (yield))
                (if (peg/match proto/g chunk)
                  (do
                    (:read-stop client)
                    (print "---done!---")
                    (break))
                  (do
                    (yield (:write client "You said "))
                    (yield (:write client chunk))
                    (yield (:write client "\n"))
                    (yield (:write client "-end-"))))))))


