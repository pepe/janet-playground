(import sqlite3 :as sql)

(def db "Opens DB" (sql/open "people.db"))

(defn get-records [table]
  "Get records from the table"
  (sql/eval db (string `SELECT * FROM ` table `;`)))

(defn close []
  "Closes DB connection")
