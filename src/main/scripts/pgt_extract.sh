#!/usr/bin/env bash
# pgt_extract.sh - Extract files from an exported tar file for importing.
# Copyright (c) 2026 Ross Greinke. All rights reserved.
# Licensed under the Apache License.
# See LICENSE file in the project root for full license information.

# Boilerplate code to source the common configuration script.
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
common_lib="${script_dir}/pgt_common.sh"
if [[ ! -f "$common_lib" ]]; then
    echo "Error: Required common library not found at $common_lib" >&2
    exit 1
fi
# shellcheck disable=SC1090
source "$common_lib"

# Clean out any old files.
"${script_dir}/pgt_clean.sh"

PS3="Select which tar file to extract (or 'q' to quit): "
select choice in ${EXPORT_DIR}/*.tar; do
    if [ "$REPLY" = "q" ]; then
        log_info "Exiting."
        break
    fi

    # Valid choice?
    if [ -n "$choice" ]; then
        tar_file=${choice}
        break
    else
        echo "Invalid choice. Please pick a number from the menu."
    fi
done

log_info "Extracting schema and data files for database ${DATABASE_NAME}..."
tar xf "${tar_file}" -C "${IMPORT_DIR}"

log_info "Unzipping schema and data files..."
gunzip "${IMPORT_DIR}/${DATABASE_NAME}.schema.gz"
gunzip "${IMPORT_DIR}/${DATABASE_NAME}.data.gz"

log_success "Done."
exit 0
