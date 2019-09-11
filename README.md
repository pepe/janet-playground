# Janet Programming language playground

Here I will put code as I am learning Janet Programming language. There is 
almost nothing to see here now.

## Usage

You will need [Janet] programming language installed on your computer.

Clone this repo, and `cd` to it. Then run `[sudo] jpm deps` do download 
dependencies.

### TCP communication

You can run simple echo server with `janet tcp-server.janet`. Server is 
implemented with [juv]. 

You can connect to it with `telnet localhost 8120`. You will receive instruction
for server controll. Protocol is defined with [PEG] from [Janet] standart 
library in file `proto.janet`.

Second approach is to run `janet tcp-client.janet` which should communicate with
the server. 

### Circlet server

You can run simple http server with `janet circlet-server.janet`. Then open
http://localhost:8130/ to the site. Benchmarking the "/" path I can get 25 
Kreq/s on my desktop computer with `wrk` and 10 concurent connections.

Next url: http://localhost:8130/playground is more involved as it uses Cookies!

#### SQLite 

If you want to try [sqlite] integration with [circlet], you have to run 
`janet setup-sqlite.janet`, which will recreate sample DB. Then on the url:
http://localhost:8130/people is list of the records from the DB in html. If you
use curl with json content type, you will receive JSON representation of it:
`curl -H "Accept: application/json" http://localhost:8130/people`


### cUrl download

Example of using [jurl] library in `curl-download.janet` program. You can run it
with `janet curl-download.janet`. It will show you http://www.google.com content
(oh no it is full of JS) and download some happy tunes.

### PEG 

PEG from the standart library is used on more places. Very simple example, taken
from [Janet] [PEG] documentation.

For me personaly [PEG] is one the greatest surprises and delights in [Janet] 
language.

### Numbers walking

Simple tree walker implemented with `walk` fn from [Janet] standart library. 


[Janet]: https://janet-lang.org/index.html
[juv]: https://github.com/janet-lang/juv
[circlet]: https://github.com/janet-lang/circlet
[PEG]: https://janet-lang.org/docs/peg.html
[jurl]: https://github.com/sepisoad/jurl
[sqlite]: https://github.com/janet-lang/sqlite3

## TODO:
- [ ] refactor
- [ ] add argparse example
- [ ] add path example
- [x] add json example
- [x] add SQLite example
- [x] add links
- [x] add usage
- [x] add tcp client example
- [x] add circlet example
