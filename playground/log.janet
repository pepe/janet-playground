(defn debug [who what]
  (printf "%f - %s - %s\n" 
          (os/time)
          (string who)
          (string what)))
