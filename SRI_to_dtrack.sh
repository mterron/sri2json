#!/bin/sh

mkdir -p /sri
while true; do
	sri2json.sh
	sri_json2postgresql.sh
	sleep 1h
done
