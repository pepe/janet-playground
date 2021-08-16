# Janet Programming language playground

Here I will put code as I am learning Janet Programming language. There is
almost nothing to see here now.

## Usage

You will need [Janet] programming language installed on your computer.

Clone this repo, and `cd` to it. Then run `[sudo] jpm deps` do download
dependencies. To run any script `cd playground`.

### TCP communication

You can run simple echo server with `janet tcp-server.janet`. Server is
implemented with [juv].

You can connect to it with `telnet localhost 8120`. You will receive instruction
for server controll. Protocol is defined with [PEG] from [Janet] standart
library in file `proto.janet`.

Second approach is to run `janet tcp-client.janet` which should communicate with
the server.

### cUrl download with jurl

Example of using [jurl] library in `basic-jurl.janet` program. You can run it
with `janet basic-jurl.janet`. It will show you http://www.google.com content
(oh no it is full of JS) and download some happy tunes.

### PEG

PEG from the standart library is used on more places. Very simple example, taken
from [Janet] [PEG] documentation can be run with `janet test-peg.janet`.

For me personaly [PEG] is one the greatest surprises and delights in [Janet]
language.

### Numbers walking

Simple tree walker implemented with `walk` fn from [Janet] standart library.

### Condarr

Simple implementation of `cond->` and `cond->>` ala clojure.

### Eventures

Adventures in the ev module.


[Janet]: https://janet-lang.org/index.html
[PEG]: https://janet-lang.org/docs/peg.html
[jurl]: https://github.com/sepisoad/jurl

