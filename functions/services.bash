#!/bin/bash

function fire() {
    docker container run -d --name memgraph -p 7687:7687 memgraph/memgraph
}

function mem_vol() {
    docker container -p 7687:7687 -d --name memgraph \
    -v mg_lib:/var/lib/memgraph \
    -v mg_log:/var/log/memgraph \
    -v mg_etc:/etc/memgraph \
    memgraph/memgraph
}


function water() {
    docker container rm -f memgraph
}
