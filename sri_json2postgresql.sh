#!/bin/sh
SCRIPT_NAME=$(basename -- "$0")

logi() {
	printf "%s [INFO] ${SCRIPT_NAME}: %s\n" "$(date -Iseconds)" "$@" >&2
}

set -e

import_to_db () {
	if [ -f /sri/import-ready ]; then
		logi 'Importing to DB'
		# You need to have $PGPASSWORD set for this to work
		logi "$(psql -U "${POSTGRES_USER:=postgres}" -h "${POSTGRES_HOST:=postgres}" -c "COPY sri (data) FROM STDIN;" < /sri/SRI.json) records imported"
		mv /sri/SRI.json /sri/SRI.json.bak
	fi
}


if [ $PGPASSWORD ]; then
	import_to_db
else
	logi '$PGPASSWORD not set, can'"'"'t connect to DB'
	exit 1
fi
