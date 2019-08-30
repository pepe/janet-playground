# Janet Programming language playground

Here I will put code as I am learning Janet Programming language. There is 
almost nothing to see here now.

## Usage

You will need Jane programming language installed on your computer.

Clone this repo, and `cd` to it. Then run `[sudo] jpm deps` do download 
dependencies.

After install is done, run simple echo server with `janet tcp-server.janet`.
Now you can connect to it with `telnet localhost 8120`. You will receive
instruction for server controll.

Second approach is to run `janet tcp-client.janet` which should communicate with
the server. But due to my lack of knowledge about the TCP protocol server errors
cause both issued messages are sent as one and then there is empty message 
(I guess) which server does not like.

## TODO:
- [x] add usage
- [ ] add links
- [x] add tcp client example
- [ ] add circlet example
