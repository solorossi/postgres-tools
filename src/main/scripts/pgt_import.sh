#!/usr/bin/env bash
# pgt_import.sh - Import schema and data into an empty database.
# Copyright (c) 2026 Ross Greinke. All rights reserved.
# Licensed under the Apache License.
# See LICENSE file in the project root for full license information.

# Boilerplate code to source the common configuration script.
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
common_lib="$script_dir/pgt_common.sh"
if [[ ! -f "$common_lib" ]]; then
    echo "Error: Required common library not found at $common_lib" >&2
    exit 1
fi
# shellcheck disable=SC1090
source "$common_lib"

# Make sure Postgres is running.
check_postgres

schema="${IMPORT_DIR}/${DATABASE_NAME}.schema"
data="${IMPORT_DIR}/${DATABASE_NAME}.data"

if [ ! -f "${schema}" -o ! -f "${data}" ]; then
    log_error "Please extract an exported tar file."
    exit 1
fi

log_info "Importing schema for database ${DATABASE_NAME}..."
$PSQL -q -o "${schema}.out" "${DATABASE_NAME}" < "${schema}"

log_info "Importing data for database ${DATABASE_NAME}..."
$PSQL -q -o "${data}.out" "${DATABASE_NAME}" < "${data}"

log_success "Done."
exit 0

