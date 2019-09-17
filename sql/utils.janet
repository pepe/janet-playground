(import sqlite3 :as sql)

(def db "Opens DB" (sql/open "people.db"))

(defn- select [table &opt & stms]
  (let [as (array/concat @["SELECT * FROM" table] stms ";")]
   (string/join as " ")))

(defn get-records [table]
  "Get records from the table"
  (sql/eval db (select table)))

(defn get-record [table id]
  "Get records from the table by the id"
  (first (sql/eval db (select table "WHERE ID=:id") {:id id})))

(defn close []
  "Closes DB connection")
