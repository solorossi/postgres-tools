#!/usr/bin/env bash
# pgt_setdb.sh - Set the current database name and owner / user.
# Copyright (c) 2026 Ross Greinke. All rights reserved.
# Licensed under the Apache License.
# See LICENSE file in the project root for full license information.

# Ensure the user's configuration directory exists.
CONF_DIR="$HOME/.pgt/conf"
mkdir -p "${CONF_DIR}"

# Declare the configuration file names.
DB_CONF="${CONF_DIR}/db.conf"
DBS_CONF="${CONF_DIR}/dbs.conf"

# If the file containing multiple, possible database names exists, choose from it.
if [ -f "${CONF_DIR}/dbs.conf" ]; then
    PS3="Select the database / owner name (or 'q' to quit): "
    select choice in $(cat "${DBS_CONF}"); do
        if [ "$REPLY" = "q" ]; then
            echo "Exiting."
            break
        fi

        # Valid choice?
        if [ -n "$choice" ]; then
            echo "DATABASE_NAME=${choice}" > "$DB_CONF"
            echo "OWNER_NAME=${choice}" >> "$DB_CONF"
            echo "Done."
            break
        else
            echo "Invalid choice. Please pick a number from the menu."
        fi
    done
else
    # Otherwise, prompt for a value.
    read -rp "Enter the database name: " choice
    echo "DATABASE_NAME=${choice}" > "$DB_CONF"
    echo "OWNER_NAME=${choice}" >> "$DB_CONF"
    echo "Done."
fi
