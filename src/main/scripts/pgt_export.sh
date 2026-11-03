#!/usr/bin/env bash
# pgt_export.sh - Export a database using the pg_dump command.
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
$PGISREADY -q
postgres_status=$?

if [ ${postgres_status} -ne 0 ]; then
    log_error "Postgres is not running; please start it."
    exit ${postgres_status}
fi

schema_file="${TEMP_DIR}/${DATABASE_NAME}.schema.gz"
schema_log="${TEMP_DIR}/${DATABASE_NAME}.schema.log"
data_file="${TEMP_DIR}/${DATABASE_NAME}.data.gz"
data_log="${TEMP_DIR}/${DATABASE_NAME}.data.log"

log_info "Exporting the schema for database ${DATABASE_NAME}..."
$PGDUMP -c -s "${DATABASE_NAME}" 2>"${schema_log}" | gzip -9 > "${schema_file}"

log_info "Exporting the data for database ${DATABASE_NAME}..."
$PGDUMP -a --disable-triggers "${DATABASE_NAME}" 2>"${data_log}" | gzip -9 > "${data_file}"

export_date=$(date +%Y-%m-%d)
tar_file="${export_date}.${USER}.${DATABASE_NAME}.export.tar"
full_tar_file="${EXPORT_DIR}/${tar_file}"

# Remove the tar file if the name already exists.
rm -f "${full_tar_file}"

log_info "Creating the exported tar file as ${full_tar_file}..."
tar -C "${TEMP_DIR}" -cf "${full_tar_file}" .
rm -f "${TEMP_DIR}"/*

log_info "Done."
exit 0
