#!/bin/sh
# You need to have $PGUSER, $PGHOST & $PGPASSWORD set for this script to work
# psql uses the libpq env variables to define username, password and host
SCRIPT_NAME=$(basename -- "$0")

logi() {
	printf "%s [INFO] ${SCRIPT_NAME}: %s\n" "$(date -Iseconds)" "$@" >&2
}

logd() {
	if [ "${DEBUG:-0}" = 1 ]; then
		printf "%s [DEBUG] ${SCRIPT_NAME}: %s\n" "$(date -Iseconds)" "$@" >&2
    fi
}
set -e

import_to_db () {
	logi "Importing $1 to DB"
	logi "$(psql -c 'COPY untracked (data) FROM STDIN;' < "$1") records imported"
	mv -f "$1" "$1.bak"
	touch "$1"
	rm -f "${JSON_PATH}/import-ready"
}


JSON_PATH="$(dirname -- "$1")"
if [ $# -eq 1 ]; then
	if [ "$PGUSER" ] && [ "$PGHOST" ] && [ "$PGPASSWORD" ] && [ -f "${JSON_PATH}/import-ready" ] && [ -f "$1" ]; then
		import_to_db "$1"
	elif [ ! -f "$1" ]; then
		logd "$1 does not exist"
		exit 1
	else
		logi 'You must set $PGUSER, $PGPASSWORD and $PGHOST to connect to PostgreSQL'
		exit 1
	fi
else
	logi 'You must provide the name of the json file to import'
	exit 1
fi
