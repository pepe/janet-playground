# Example peg usage. All code taken from janet-lang PEG doc

(def ipv4-address
  (peg/compile
    '{:dig (range "09")
      :0-4 (range "04")
      :0-5 (range "05")
      :byte (<- (+ (* "25" :0-5)
                   (* "2" :0-4 :dig)
                   (* "1" :dig :dig)
                   (* 1 2 :dig)))
      :main (* :byte "." :byte "." :byte "." :byte)}))

(pp (peg/match ipv4-address "255.255.255.255"))
