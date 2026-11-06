#!/usr/bin/env bash
# pgt_vacuum.sh - Run vacuum and optionally analyze a database.
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
analyze_flag=""
verbose_flag=""

usage() {
    cat <<EOF
Usage: $0 [-a] [-v]

Options:
  -a  Include --analyze (-z) option
  -v  Verbose output (--verbose)
  --help Display this help and exit
EOF
    exit 1
}

# Parse the command line options.
while getopts "av" opt; do
    case ${opt} in
    a) analyze_flag="--analyze" ;;
    v) verbose_flag="--verbose" ;;
    *) usage ;;
    esac
done

#Process the options to construct the argument list.
mode="vacuum"
vacuum_args=""
if [ -n "${verbose_flag}" ]; then
    vacuum_args+=" ${verbose_flag}"
fi

if [ -n "${analyze_flag}" ]; then
    vacuum_args+=" ${analyze_flag}"
    mode+=" and analyze"
fi

# Specific output to include or exclude.
inclusions="vacuuming|analyzing"
exclusions="pg_catalog|pg_toast|information_schema"

log_info "Running ${mode} on database ${DATABASE_NAME}..."
$VACUUMDB ${vacuum_args} "${DATABASE_NAME}" 2>&1 | grep -E ${inclusions} | grep -v -E ${exclusions}

log_success "Done."
exit 0
