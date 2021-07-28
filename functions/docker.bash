#!/bin/bash

function docker-clean() {
    docker rm -f $(docker ps -a -q)
}

function docker-annihilate() {
    docker rmi $(docker images -q)
}
