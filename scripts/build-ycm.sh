#!/bin/bash
# This script must be run from the dotfiles root folder.

source scripts/utils.sh

check_cmd() {
    local cmd="$1"
    which "$cmd" &>/dev/null
    check "find command $cmd in path."
}

check_folder() {
    local folder="$1"
    [[ -d "$folder" ]]; check "find folder $folder."
}

ycm_folder=~/.vim/bundle/youcompleteme
check_folder "$ycm_folder"

check_cmd "python"
check_cmd "cmake"

cd "$ycm_folder"; check "change to $ycm_folder"

search_for="Python.h"
if [[ "$(uname)" == "Linux" ]]; then
    count=$(find /usr/include -name "$search_for" | wc -l)
    (( count > 0 ))
    check "find any $search_for files under /usr/include/.../\n" \
          "you may need to apt install python-dev or python3-dev."
else
    msg "*** WARNING: not checking for $search_for because not on Linux."
fi

./install.py --clang-completer; check "run install.py script."

msg "Finished building YCM."
