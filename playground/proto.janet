(def end "-end-")

(def message-grammar
  (peg/compile
    ~{:end ,end
      :message '(to (+ -1 :end))
      :main (* :message (? ':end))}))

(defn parse [chunk]
  (peg/match message-grammar chunk))
