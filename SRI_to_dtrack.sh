#!/bin/sh

mkdir -p /sri
while true; do
	sri2json.sh
	json2postgresql.sh /sri/SRI.json
	sleep 1h
done
