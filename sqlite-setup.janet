(import sqlite3 :as sql)

(def db (sql/open "people.db"))

(sql/eval db `DROP TABLE IF EXISTS people`)
(sql/eval db `CREATE TABLE people(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT);`)

(loop [person :in [{:name "John Doe" :phone "77788899"}
                   {:name "Jack Ripper" :phone "77766699"}
                   {:name "Jeffrey No" :phone "22288899"}
                   {:name "Jim Tim" :phone "77788833"}
                   {:name "Jose Best" :phone "44448899"}]]
  (sql/eval db `INSERT INTO people (name, phone) VALUES(:name, :phone);` person))

(let [records (sql/eval db `SELECT * FROM people;`)]
  (print "There are " (length records) " records in DB:")
  (loop [record :in records] 
    (pp record)))

(sql/close db)
