(defn debug [who what]
  (printf "%f - %s - %s\n"
          (os/clock)
          (string who)
          (string what)))
