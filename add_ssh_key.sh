#!/bin/bash
# Script used to deploy ssh key on multiple
# hosts
# Prerequisites:
# - sshpass: a program used to authenticate on all hosts via script
# - file: `hosts` with all hosts on which to deploy ssh key
# - file containing password for the hosts used by sshpass
#
# How to run?
# - pass argument specifying ssh key like this:
# ./add_ssh_key.sh 

HOSTS_FILE=${1}
PUB_KEY_FILE=${2}

HOSTS=$(cat $HOSTS_FILE)

if [ -z "${PUB_KEY_FILE}" ]; then
    echo "No public key specified!"
    exit 1
fi
echo $HOSTS
for HOSTS in ${HOSTS}; do
    echo "Copying ssh-key " to "${HOSTS}"
    sshpass -f pass.txt ssh-copy-id -i ${1} mg@${HOSTS}
done
