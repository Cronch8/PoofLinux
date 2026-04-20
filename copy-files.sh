#!/bin/bash

# actually it hard-links, not copies, to save space, but whatever.

set -euo pipefail

if [ $# -ne 3 ]; then
    echo "Usage: $0 <current_bin_directory> <new_inconsistent_executable_dir> <file_to_copy_everywhere>"
    exit 1
fi

ORIGNAL_DIR="$1"
NEW_EXECUTABLE_DIR="$2"
CHOSEN="$3"

if [ ! -d "$ORIGNAL_DIR" ]; then
    echo "error: source directory '$ORIGNAL_DIR' does not exist"
    exit 1
fi

if [ ! -f "$CHOSEN" ]; then
    echo "error: chosen file '$CHOSEN' does not exist"
    exit 1
fi

mkdir -p "$NEW_EXECUTABLE_DIR"

for file_path_to_copy in "$ORIGNAL_DIR"/*; do
    [ -e "$file_path_to_copy" ] || continue  # skip if glob matched nothing
    #original_filename="$(basename "$file_path_to_copy")"
    original_filename="${file_path_to_copy##*/}"
    dest_path="$NEW_EXECUTABLE_DIR/$original_filename"
    ln -f "$CHOSEN" "$dest_path"
    echo "linked: $dest_path -> $CHOSEN"
done
