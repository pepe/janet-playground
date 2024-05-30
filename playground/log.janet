(defn log
  "Prints logging message on stderr"
  [who & what]
  (eprintf "%f - %s - %s\n"
          (os/clock)
          (string who)
          (string ;what)))
