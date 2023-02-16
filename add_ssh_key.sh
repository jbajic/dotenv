#!/bin/bash

# Prerequisites:
# - sshpass
# - file: `hosts`` with all hosts on which to deploy ssh key
# - file containing password for the hosts
#
# How to run?
# - pass argument specifying ssh key



hosts_ips=$(cat hosts)

if [ -z "$1" ]; then
    echo "No public key specified!"
    exit 1
fi
echo $hosts
for host_ip in ${hosts_ips}; do
    echo "Copying ssh-key " to "${host_ip}"
    sshpass -f pass.txt ssh-copy-id -i ${1} mg@${host_ip}
done
