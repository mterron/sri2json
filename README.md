# sri2json

This script parses the CDNJS "new_website" repo for SRI hashes and export them to a simple json file.

The example Docker container uses libpq default env variables (in particular PGHOST, PGUSER and PGPASSWORD or PGPASSFILE are required) to export the results of parsing this tree to a PostgreSQL database.
