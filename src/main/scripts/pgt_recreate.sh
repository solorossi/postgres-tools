#!/usr/bin/env bash
# pgt_recreate.sh - Drop and recreate the database.
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

# Drop and recreate the database.
echo "Dropping and recreating database ${DATABASE_NAME}..."
$DROPDB "${DATABASE_NAME}"
$CREATEDB -O "${OWNER_NAME}" "${DATABASE_NAME}"

echo "Done."
exit 0
