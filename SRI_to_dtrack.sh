#!/bin/sh

mkdir -p /sri
while true; do
	sri2json.sh
	if [ -f /sri/import-ready ]; then
		json2postgresql.sh /sri/SRI.json
	fi
	rm -f /sri/import-ready
	sleep 1h
done
