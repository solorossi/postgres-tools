#!/usr/bin/env bash
# pgt_common.sh - Common functions and variables shared by most scripts.
# Copyright (c) 2026 Ross Greinke. All rights reserved.
# Licensed under the Apache License.
# See LICENSE file in the project root for full license information.

# Log informational messages
log_info() {
    echo -e "[\033[0;34mINFO\033[0m] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# HLog error messages
log_error() {
    echo -e "[\033[0;31mERROR\033[0m] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2
}

get_postgres_bin() {
    # Method 1: Check using pg_config (most reliable if in the PATH)
    if command -v pg_config &>/dev/null; then
        # shellcheck disable=SC2005
        echo "$(pg_config --bindir)"
        return 0
    fi

    # Method 2: Check via the currently running postgres process
    local pg_proc
    pg_proc=$(ps -ef | grep -E '[p]ostgres|[p]ostmaster' | awk '{print $8}' | head -n 1)
    if [ -n "$pg_proc" ] && [[ "$pg_proc" == *"bin/postgres"* ]]; then
        # shellcheck disable=SC2005
        echo "$(dirname "$pg_proc")"
        return 0
    fi

    return 1
}

# Run the function and capture the result.
pg_bin_dir=$(get_postgres_bin)
if [ $? -eq 1 ]; then
    log_error "Could not detect PostgreSQL bin directory. Please set the PATH."
    exit 1
fi

# Set up global shell variables for the Postgres CLI tools.
CREATEDB="${pg_bin_dir}/createdb"
CREATEUSER="${pg_bin_dir}/createuser"
DROPDB="${pg_bin_dir}/dropdb"
PGDUMPALL="${pg_bin_dir}/pg_dumpall"
PGISREADY="${pg_bin_dir}/pg_isready"
PGDUMP="${pg_bin_dir}/pg_dump"
PSQL="${pg_bin_dir}/psql"
VACUUMDB="${pg_bin_dir}/vacuumdb"

# Ensure the user's configuration directories exist.
HOME_PGT_DIR="$HOME/pgt"
conf_dir="${HOME_PGT_DIR}/conf"
mkdir -p "${conf_dir}"
db_conf="${conf_dir}/db.conf"

# Check and get the current database name.
if [ ! -f "${db_conf}" ]; then
    log_error "Current database name not set. Please use pgt_setdb.sh to set the current database name."
    exit 1
fi
# shellcheck disable=SC1090
source "${db_conf}"

# Set up global shell variables for the Postgres Tools.
IMPORT_DIR="${HOME_PGT_DIR}/import"
mkdir -p "${IMPORT_DIR}"
EXPORT_DIR="${HOME_PGT_DIR}/export"
mkdir -p "${EXPORT_DIR}"
TEMP_DIR="${HOME_PGT_DIR}/tmp"
mkdir -p "${TEMP_DIR}"
