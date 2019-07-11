#!/bin/sh
# You need to have $PGPASSWORD set for this to work
set -e

import_to_db () {
	if [ -f /sri/import-ready ]; then
		echo 'Importing to DB' >&2
		psql -U "${POSTGRES_USER:=postgres}" -h "${POSTGRES_HOST:=postgres}" -c "COPY sri (data) FROM STDIN;" < /sri/SRI.json
		mv /sri/SRI.json /sri/SRI.json.bak
	fi
}

import_to_db
