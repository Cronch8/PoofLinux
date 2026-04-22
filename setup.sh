#!/bin/bash

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "sudo is required. Re-run this with sudo privilages."
    exit 1
fi

set -euo pipefail

# save a copy of the commands so it wont break while moving stuff
mkdir -p ./command-backup
cp /bin/cp    ./command-backup/.
cp /bin/mv    ./command-backup/.
cp /bin/ln    ./command-backup/.
cp /bin/echo  ./command-backup/.
cp /bin/test  ./command-backup/.
cp /bin/mkdir ./command-backup/.
PATH="$(pwd)/command-backup:$PATH"

# move this to avoid hard-link filesystem partition boundry problems
cp ./relaunch /relaunch

# move the true /bin dir over
original_bin_path="/usr/bin"
mv "$original_bin_path" /bin-copy

mkdir -p "$original_bin_path"
# set up executables that will be calling into the original, moved /bin
for file_path_to_copy in /bin-copy/*; do
    test -e "$file_path_to_copy" || continue  # skip if glob matched nothing
    # hardlink the relaunch application to have the same path as the old /bin item
    filename="${file_path_to_copy##*/}"
    ln -f "/relaunch" "$original_bin_path/$filename" 
    echo "linked: $original_bin_path/$filename -> /relaunch"
    #break
    #exit 1
done
