(import sqlite3 :as sql)

(def db (sql/open "test.db"))

(sql/eval db `CREATE TABLE customers(id INTEGER PRIMARY KEY, name TEXT);`)

(sql/eval db `INSERT INTO customers VALUES(:id, :name);` {:name "John" :id 12345})

(pp (sql/eval db `SELECT * FROM customers;`))

(sql/close db)
