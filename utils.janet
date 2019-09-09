(defn number-suffix 
  "Adds english suffix to order number"
  [num]
  (if (< 10 num 14)
    "th"
    (case (% num 10)
          1 "st"
          2 "nd"
          3 "rd"
          "th")))

