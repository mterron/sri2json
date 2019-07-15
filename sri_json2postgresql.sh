#!/bin/sh
# You need to have $PGUSER, $PGHOST & $PGPASSWORD set for this script to work
SCRIPT_NAME=$(basename -- "$0")

logi() {
	printf "%s [INFO] ${SCRIPT_NAME}: %s\n" "$(date -Iseconds)" "$@" >&2
}

set -e

import_to_db () {
	if [ -f /sri/import-ready ]; then
		logi 'Importing to DB'
		# psql uses the lipq env variable to define username, password and host
		logi "$(psql -c "COPY sri (data) FROM STDIN;" < /sri/SRI.json) records imported"
		mv /sri/SRI.json /sri/SRI.json.bak
		rm -f /sri/import-ready
	fi
}

if [ $PGUSER ] && [ $PGHOST ] && [ $PGPASSWORD ]; then
	import_to_db
else
	logi 'You must set $PGUSER, $PGPASSWORD and $PGHOST to connect to PostgreSQL'
	exit 1
fi
