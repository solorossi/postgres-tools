#!/usr/bin/env bash
# pgt_create.sh - Create a new owner / user and database on an empty, initialized engine.
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

# Create the owner / user and database.
log_info "Creating owner / user ${OWNER_NAME}..."
$CREATEUSER -P -d "${OWNER_NAME}"

log_info "Creating database ${DATABASE_NAME}..."
$CREATEDB -O "${OWNER_NAME}" "${DATABASE_NAME}"

log_success "Done."
exit 0
