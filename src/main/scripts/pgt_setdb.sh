#!/usr/bin/env bash
# pgt_setdb.sh - Set the current database name and owner / user.
# Copyright (c) 2026 Ross Greinke. All rights reserved.
# Licensed under the Apache License.
# See LICENSE file in the project root for full license information.

# Log informational messages (green)
log_success() {
    echo -e "[\033[0;32m OK \033[0m] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Log informational messages
log_info() {
    echo -e "[\033[0;34mINFO\033[0m] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Ensure the user's configuration directory exists.
conf_dir="$HOME/pgt/conf"
mkdir -p "${conf_dir}"

# Declare the configuration file names.
database_conf="${conf_dir}/database.conf"
databases_conf="${conf_dir}/databases.conf"

# If the file containing multiple, possible database names exists, choose from it.
if [ -f "${databases_conf}" ]; then
    PS3="Select the database / owner name (or 'q' to quit): "
    select choice in $(cat "${databases_conf}"); do
        if [ "$REPLY" = "q" ]; then
            log_info "Exiting."
            break
        fi

        # Valid choice?
        if [ -n "$choice" ]; then
            log_info "Setting the current database name and owner name to ${choice}..."
            echo "DATABASE_NAME=${choice}" > "${database_conf}"
            echo "OWNER_NAME=${choice}" >> "${database_conf}"
            log_success "Done."
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
    log_info "Setting the current database name and owner name to ${choice}..."
    echo "DATABASE_NAME=${choice}" > "${database_conf}"
    echo "OWNER_NAME=${choice}" >> "${database_conf}"
    log_success "Done."
fi

exit 0
