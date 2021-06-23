#!/bin/bash

function docker-prune() {
    docker containers prune
    docker volume prune
    docker network prune
}

function docker-clean() {
    docker rm -f $(docker ps -a -q)
}

function docker-annihilate() {
    docker rmi $(docker images -q)
}
