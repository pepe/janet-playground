(import sqlite3 :as sql)

(def db "Opens DB" (sql/open "people.db"))

(defn- select [table &opt & stms]
  (string/join 
    (array/concat @["SELECT * FROM" table] ;stms ";")
    " "))

(defn get-records [table]
  "Get records from the table"
  (sql/eval db (select table)))

(defn get-record [table id]
  "Get records from the table by the id"
  (first (sql/eval db (select table "WHERE ID=:id") {:id id})))

(defn find-records [table bnd]
  "Get records from the table by the id"
  (sql/eval db (select table (if (empty? bnd) [] ["WHERE" ;(seq [[k v] :pairs bnd] (string k "=:" k))])) bnd))

(defn close []
  "Closes DB connection")
