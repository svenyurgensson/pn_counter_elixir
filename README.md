# PnCounter

My attempt to implement distributed CRDT PN-Counter

## Getting code and dependancies

    git clone https://github.com/svenyurgensson/pn_counter_elixir.git

    cd pn_counter_elixir/
    mix deps.get

## Starting nodes

Master node should be started as:

    elixir --name counter --cookie sound -S mix run --no-halt

Server has predefined master node `counter@jurmacbookpro.local`
It should be changed to something more acceptable in `lib/pn_counter/counter.ex`

Worker node should be started as:

    elixir --name %NAME% --cookie sound -S mix run --no-halt

Where %NAME% represents name of given node

## Making http requests

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
