# Example curl. All code taken from https://github.com/sepisoad/jurl.git
(import curl :as curl)

(defn fetch
  "Simple url fetch. Returns string with the content of the resource."
 [url] 
  (def c (curl/easy/init))
  (def b (buffer))
  (:setopt c
           :url url
           :write-function (fn [buf] (buffer/push-string b buf))
           :no-progress? true)
  (:perform c)
  (string b))

(defn download
  "Download a file with curl easy and progress"
  [url &opt to]
  (default to (last (string/split "/" url)))
  (def c (curl/easy/init))
  (with [file (file/open to :wb)]
    (var run-yet false)
    (defn progress [a b c d]
      "Progress function while downloading"
      (if (zero? b) (break))
      (def out-of-50 
        (let [x (math/floor (/ (* b 50) a))]
          (if (= x x) x 0)))
      (def rest (- 50 out-of-50))
      (if run-yet
        (:write stdout "\e[F\e[F"))
      (set run-yet true)
      (print "Downloading \e[36m" url "\e[0m - \e[31m" (/ a (* 1024 1024)) " MBytes\n\e[34m  ["
             (string/repeat "." out-of-50) (string/repeat " " rest)  "]\e[0m"))
    (:setopt c
             :url url
             :write-function (fn [buf] (file/write file buf))
             :no-progress? false
             :progress-function progress)
    (:perform c)
    (print "Wrote to \e[36m" to "\e[0m")))

(print "Content of https://google.com:\n" (fetch "https://google.com"))
(print (string/repeat "-" 80) "\n")

(download "https://upload.wikimedia.org/wikipedia/commons/7/79/Big_Buck_Bunny_small.ogv"
                   "DOWNLOAD")
