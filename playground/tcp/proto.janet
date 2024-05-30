(def message-grammar
  "Grammar for tcp message"
  (peg/compile
    ~{:end "-end-"
      :message '(to (+ -1 :end))
      :main (* :message (? ':end))}))

(defn parse
  "Returns parsed `message`"
  [message]
  (peg/match message-grammar message))
