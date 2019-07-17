#!/bin/sh
SCRIPT_NAME=$(basename -- "$0")

logi() {
	printf "%s [INFO] ${SCRIPT_NAME}: %s\n" "$(date -Iseconds)" "$@" >&2
}

process_sri_tree() {
	cd "${WORKDIR}"/new-website
	logi 'Processing SRI tree'
	git --no-pager log --pretty="format:" --name-only --since="$(date -Iseconds -r /sri/last-run)" -- sri | sort | uniq | xargs -r -n1 -P1 jq --unbuffered -M '{component: (input_filename|split("/"))[1], version: ((input_filename|split("/"))[2]|sub(".json"; "")), hashes: [ to_entries[] | {file: .key, (.value|scan("(.*)-")[]): (.value|sub("(.*-)"; "")) } ] }' 2>/dev/null | awk -F: -v decode_sha256="base64 -d - 2>/dev/null | xxd -p -c32 | tr -cd '[:xdigit:]'" '{ if ( $1 ~ "sha256") { ORS="";print $1": \""; print $2 | decode_sha256; close(decode_sha256); print "\"\n";ORS="\n" } else print $0 }' | jq -M -c '.' >/sri/SRI.json
	logi 'Processing SRI tree done'
	touch -d "$(date -d "@$(git log -1 --format=%ct)" +%Y%m%d%H%M.%S)" /sri/last-run
	touch /sri/import-ready
}

set -e

cd "${WORKDIR:=/tmp}" || exit 1


# Initialise last-run file
if ! [ -f /sri/last-run ]; then
	touch -d 1980-01-01 -t 1980-01-01 /sri/last-run || exit 1
fi

# Update sri tree from git repo
if [ -d new-website/ ]; then
	logi 'Updating SRI repo'
	cd "${WORKDIR}"/new-website/
	if ! [  "$(git pull)" = 'Already up to date.' ]; then
		process_sri_tree
	fi
else
	logi 'Cloning SRI repo'
	git clone -q https://github.com/cdnjs/new-website.git
	cd "${WORKDIR}"/new-website
	# git configuration
	git config diff.renameLimit 999999
	git config diff.suppressBlankEmpty true
	process_sri_tree
fi
