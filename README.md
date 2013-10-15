# PnCounter

My naive attempt to implement distributed CRDT PN-Counter

### Getting code and dependancies

    git clone https://github.com/svenyurgensson/pn_counter_elixir.git pn_counter

    cd pn_counter/
    mix deps.get

### Starting nodes

Master node should be started as:

    elixir --name counter --cookie sound -S mix run --no-halt

Server has predefined master node `counter@jurmacbookpro.local`
It should be changed to something more acceptable in `lib/pn_counter/counter.ex`

Worker node should be started as:

    elixir --name %NAME% --cookie sound -S mix run --no-halt

Where %NAME% represents name of given node

### Making http requests

Get current counter value:

    >curl -i -X GET http://localhost:8000/counter
    HTTP/1.1 200 OK
    connection: keep-alive
    server: Cowboy
    date: Tue, 15 Oct 2013 04:32:47 GMT
    content-length: 1

Increment value:

    >curl -i -X POST http://localhost:8000/counter/increment
    HTTP/1.1 201 Created
    connection: keep-alive
    server: Cowboy
    date: Tue, 15 Oct 2013 04:32:37 GMT
    content-length: 0

Decrement value:

    >curl -i -X POST http://localhost:8000/counter/decrement
    HTTP/1.1 201 Created
    connection: keep-alive
    server: Cowboy
    date: Tue, 15 Oct 2013 04:51:18 GMT
    content-length: 0


### Theory and papers based on

Here are links to more info about Convergent Replicated Data Types (the state-based variant):

- [A comprehensive study of Convergent and Commutative Replicated Data Types](http://hal.upmc.fr/docs/00/55/55/88/PDF/techreport.pdf) [PDF] - This describes the concepts behind CRDTs, both state-based (convergent, aka CvRDTs) and operation-based (commutative, aka CmRDTs).
- [basho/riak_kv riak_kv_counter.erl](https://github.com/basho/riak_kv/blob/master/src/riak_kv_counter.erl) - The source code of the counter implementation, with notes about which CRDT is actually used (PN-Counters, if you're wondering).
- [Data Structures in Riak - RICON 2012](http://vimeo.com/52414903) - A talk by Sean Cribbs and Russell Brown at RICON 2012, including a proof-of-concept implementation of CRDTs in Riak. There's a demo at about [28:30](http://vimeo.com/52414903#t=28m37s) that shows what happens during and after a network partition.
- [A Cookbook full of Tutorials to get Developers started with Riak's CRDTs](https://github.com/basho/riak_crdt_cookbook)
