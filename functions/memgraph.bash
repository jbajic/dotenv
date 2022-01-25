#!/bin/bash

function vpn() {
	pushd "${HOME}/Documents/VPNS"
	pwd
	local ARG=${1:-unknown}
	case ${ARG} in
	  aws)
		sudo openvpn --config jurebajic-memgraph.ovpn
		;;
	  infra)
		sudo openvpn --config memgraph.ovpn
		;;
	  *)
	    echo "Please select either infra or aws VPN!"
		;;
	esac
	popd
}

function fire() {
	local port=${1:-7687}
	local name=${2:-memgraph_db}
	local query_module=${3:-/home/bajic/Stuff/memgraph/query_modules}

	docker container run --rm --name ${name} -d -p ${port}:7687 \
	-v /home/bajic/Stuff/memgraph/memgraph.conf:/etc/memgraph/memgraph.conf:ro \
	-v ${query_module}:/usr/lib/memgraph/query_modules \
	memgraph
}

function fire_storage() {
	local port=${1:-7687}
	local name=${2:-memgraph_db}
	local query_module=${3:-/home/bajic/Stuff/memgraph/query_modules}

	local backup="/home/bajic/Stuff/memgraph/backup"
	local data_dir="/home/bajic/Stuff/memgraph/data"

	docker container run --rm --name ${name} -d -p ${port}:7687 \
	-v ${query_module}:/usr/lib/memgraph/query_modules \
	-v mem_backup:/home/backup \
    -v mg_log:/var/log/memgraph \
	-v mg_lib:/var/lib/memgraph \
	-v /home/bajic/Stuff/memgraph/memgraph.conf:/etc/memgraph/memgraph.conf:ro \
	memgraph
}

function neo4j_run() {
	docker run \
    --publish=7474:7474 --publish=7687:7687 \
	-d --name neo4j --rm \
    neo4j:3.5.22-community
}

function water() {
	local port=${1:-7687}
	local name=${1:-memgraph_db}

	docker container stop ${name}
}

function dbg_mem() {
	# Minimum log level. Allowed values: TRACE, DEBUG, INFO, WARNING, ERROR, CRITICAL
	local log_level=${1:-TRACE}
	build/memgraph \
		--also-log-to-stderr \
		--log-file='' \
		--log-level=${log_level} \
		--telemetry-enabled=false \
		--data-directory=/home/bajic/Stuff/memgraph/data-dir \
		--storage-properties-on-edges \
		--query-execution-timeout-sec=0 \
		--storage-recover-on-startup=true \
		--bolt-server-name-for-init=Neo4j/1.0 \
		--kafka-bootstrap-servers=localhost:9092 \
		--query-modules-directory=/home/bajic/Stuff/memgraph/query_modules
}

function gdb_mem() {
	gdb --args build/memgraph \
		--also-log-to-stderr \
		--log-file='' \
		--log-level=TRACE \
		--telemetry-enabled=False \
		--data-directory=/home/bajic/Stuff/memgraph/data-dir \
		--storage-properties-on-edges \
		--query-execution-timeout-sec=0 \
		--storage-recover-on-startup=true \
		--bolt-server-name-for-init=Neo4j/1.0 \
		--kafka-bootstrap-servers=localhost:9092 \
		--query-modules-directory=/home/bajic/Stuff/memgraph/query_modules
}

function sm() {
	source /opt/toolchain-v4/activate
}