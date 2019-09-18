(import tester :prefix "")
(import ../src/http/helpers :as http/helpers)

(deftest 
  (test "encode escape chars"
        (= (http/helpers/encode " <>#%{}|\\^~[]`;/?:@=&$") 
           "%20%3C%3E%23%25%7B%7D%7C%5C%5E%7E%5B%5D%60%3B%2F%3F%3A%40%3D%26%24"))
  (test "decode escape chars"
        (= (http/helpers/decode "%20%3C%3E%23%25%7B%7D%7C%5C%5E%7E%5B%5D%60%3B%2F%3F%3A%40%3D%26%24") 
           " <>#%{}|\\^~[]`;/?:@=&$")))
