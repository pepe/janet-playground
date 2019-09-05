(defn walker [f &opt level]
  (default level 0)
  (fn [form]
    (if (or (indexed? form) (dictionary? form))
      (walk (walker f (f level)) form)
      (print (string/repeat "-" level) ">" (string/repeat "=" ((if (> level form) - +) level form))))))

(walk (walker dec 10)  [[[[0 1 3]] 10 7 [3 [3 5]] 3 4] 1 [3 4]])
(walk (walker inc)  [[[[0 1 3]] 16 7 [3 [3 5]] 3 4] 1 [3 4]])
