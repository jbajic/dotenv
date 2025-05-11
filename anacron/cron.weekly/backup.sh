#!/bin/bash

pushd /home/jbajic
  rustic backup
  curl https://healthchecks.tail3c8e.ts.net/ping/754df10b-1ac8-4031-a001-eca9c42f2ac5
popd
