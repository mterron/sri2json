#!/bin/sh
# You need to have $PGUSER, $PGHOST & $PGPASSWORD set for this script to work
SCRIPT_NAME=$(basename -- "$0")

logi() {
	printf "%s [INFO] ${SCRIPT_NAME}: %s\n" "$(date -Iseconds)" "$@" >&2
}

set -e

import_to_db () {
	PATH="$(dirname -- $1)"
	set -f
	if [ -f "${PATH}/import-ready" ]; then
		# logi 'Importing to DB'
		# psql uses the libpq env variables to define username, password and host
		logi "$(psql -c 'COPY untracked (data) FROM STDIN;' < $1) records imported"
		mv -f "$1" "$1.bak"
		rm -f "${PATH}/import-ready"
	fi
}

if [ $# -eq 1 ]; then
	if [ $PGUSER ] && [ $PGHOST ] && [ $PGPASSWORD ]; then
		import_to_db "$1"
	else
		logi 'You must set $PGUSER, $PGPASSWORD and $PGHOST to connect to PostgreSQL'
		exit 1
	fi
else
	logi 'You must provide the name of the json file to import'
	exit 1
fi
