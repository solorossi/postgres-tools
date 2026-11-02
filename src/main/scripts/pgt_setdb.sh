#!/usr/bin/env bash
# pgt_setdb.sh - Set the current database name and owner / user.
# Copyright (c) 2026 Ross Greinke. All rights reserved.
# Licensed under the Apache License.
# See LICENSE file in the project root for full license information.

# Ensure the user's configuration directory exists.
conf_dir="$HOME/pgt/conf"
mkdir -p "${conf_dir}"

# Declare the configuration file names.
db_conf="${conf_dir}/db.conf"
dbs_conf="${conf_dir}/dbs.conf"

# If the file containing multiple, possible database names exists, choose from it.
if [ -f "${conf_dir}/dbs.conf" ]; then
    PS3="Select the database / owner name (or 'q' to quit): "
    select choice in $(cat "${dbs_conf}"); do
        if [ "$REPLY" = "q" ]; then
            echo "Exiting."
            break
        fi

        # Valid choice?
        if [ -n "$choice" ]; then
            echo "DATABASE_NAME=${choice}" > "$db_conf"
            echo "OWNER_NAME=${choice}" >> "$db_conf"
            echo "Done."
            break
        else
            echo "Invalid choice. Please pick a number from the menu."
        fi
    done
else
    # Otherwise, prompt for a value.
    choice=""
    while [ -z "$choice" ]; do
        read -rp "Enter the database name: " choice
        choice=$(echo "$choice" | xargs)
    done
    echo "DATABASE_NAME=${choice}" > "$db_conf"
    echo "OWNER_NAME=${choice}" >> "$db_conf"
    echo "Done."
fi
