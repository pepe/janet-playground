(import jurl)

(print "Content of https://google.com:\n" (jurl/fetch "https://www.google.com"))
(print (string/repeat "-" 80) "\n")

(jurl/download "https://upload.wikimedia.org/wikipedia/commons/7/79/Big_Buck_Bunny_small.ogv"
                   "DOWNLOAD")

