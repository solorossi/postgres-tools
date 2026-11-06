#!/usr/bin/env bash
# pgt_runsql.sh - Run the psql tool to execute SQL commands from a file.
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

# Default values.
sql_file=""
output_dir=""

usage() {
    cat <<EOF
Usage: $0 -f <sql-file> [-o output-dir]

Options:
  -f  The SQL file to run
  -o  Directory to use for output (defaults to sql file directory)
  --help Display this help and exit
EOF
    exit 1
}

# Parse the command line options.
while getopts "f:o:" opt; do
    case ${opt} in
    f) sql_file="${OPTARG}" ;;
    o) output_dir="${OPTARG}" ;;
    *) usage ;;
    esac
done

if [ -z "$sql_file" ]; then
    log_error "SQL file (-f) is required."
    usage
fi

# Get the directory containing the SQL file.
sql_dir=$(dirname "$(realpath "${sql_file}")" )
if [ -z "$output_dir" ]; then
    output_dir="${sql_dir}"
fi

# Get the base portion of the sql file name (i.e. remove extension)
sql_file_base="$(basename "${sql_file%.*}")"

# Prepare the output file names.
mkdir -p "${output_dir}"
output_file="${output_dir}/${sql_file_base}.out"
log_file="${output_dir}/${sql_file_base}.log"
error_file="${output_dir}/${sql_file_base}.err"

# Log files (-L argument) appends; empty it out.
: > "${log_file}"

log_info "Running SQL commands from ${sql_file} for database ${DATABASE_NAME}..."
$PSQL -a -1 -d "${DATABASE_NAME}" -U "${OWNER_NAME}" -f "${sql_file}" -o "${output_file}" -L "${log_file}" > /dev/null 2>"${error_file}"

if [ -s "${error_file}" ]; then
    log_warning "Please check the contents of ${error_file}"
fi

log_success "Done."
exit 0