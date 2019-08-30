# Example tcp client. Use it with example tcp server. All code taken from juv test
(import uv)

(uv/enter-loop 
  (def client (uv/tcp/new))
  (def conn (uv/tcp/connect client "0.0.0.0" 8120))
  (yield (:write conn @"ext"))
  (yield (:write conn @"exit"))
  (yield))
