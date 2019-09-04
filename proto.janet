(def end "-end-")

(def message-grammar
  (peg/compile
    {:message '(<- (any (+ (range "09") (range "az") (range "AZ") (set " ?,.;:!\n"))) :message) 
     :end ~(<- (any ,end)) 
     :main '(* :message :end)}))

(defn parse [chunk]
 (peg/match message-grammar chunk))
