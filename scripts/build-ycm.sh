#!/bin/bash

die() {
    echo -e "$*" 1>&2
    exit 1
}

check_cmd() {
    local cmd="$1"
    which "$cmd" &>/dev/null || die "command ($cmd) not found in path."
}

check_folder() {
    local folder="$1"
    [[ -d "$folder" ]] || die "folder $folder not found."
}

ycm_folder=~/.vim/bundle/youcompleteme
check_folder "$ycm_folder"

check_cmd "python"
check_cmd "cmake"

cd "$ycm_folder" || die "failed to change to $ycm_folder"

search_for="Python.h"
if [[ "$(uname)" == "Linux" ]]; then
    count=$(find /usr/include -name "$search_for" | wc -l)
    (( count > 0 )) || {
        die "failed to find any $search_for files under /usr/include/.../\n" \
            "you may need to apt install python-dev or python3-dev."
    }
else
    echo "*** WARNING: not checking for $search_for because not on Linux."
fi

./install.py --clang-completer || die "Failed during installation."

echo "Finished."
