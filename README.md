# Janet Programming language playground

This repository contains code which demonstrates some of the features 
of the Janet programming language.

## Usage

You will need [Janet] programming language installed on your computer.

Clone this repo, and `cd` to it. Then run `jpm -l deps` to download
`spork` dependency.

### TCP communication

You can run simple echo server with `janet playground/tcp/server.janet`. Server is
implemented with core network capabilities.

You can connect to it with `telnet localhost 8120`. You will receive instruction
for server controll. Protocol is defined with [PEG] from [Janet] standart
library in file `proto.janet`.

Second approach is to run `janet playground/tcp/client.janet` which should communicate
with the server.

### PEG

PEG from the standart library is used on more places. Very simple example, taken
from [Janet] [PEG] documentation can be run with `janet test-peg.janet`.

For me personaly [PEG] is one the greatest surprises and delights in [Janet]
language.

### Numbers walking

Simple tree walker implemented with `walk` fn from [Janet] standart library.

### Eventures

Adventures in the ev module.


[Janet]: https://janet-lang.org/index.html
[PEG]: https://janet-lang.org/docs/peg.html
[jurl]: https://github.com/sepisoad/jurl

