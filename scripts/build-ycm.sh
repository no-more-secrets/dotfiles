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

tools="$HOME/dev/tools"

llvm_root=$tools/llvm-current
if [[ -e "$llvm_root" ]]; then
    msg "Found LLVM root for libclang: $llvm_root"
    # The install script below will eventually invoke CMake, and it
    # will append these args.  This LLVM root argument will cause
    # the build system to use the libclang in that location for the
    # clang completer.  It will do this by directly linking the
    # third_party/ycmd/ycmd_core.so to the libclang.so that it finds.
    export EXTRA_CMAKE_ARGS="-DPATH_TO_LLVM_ROOT=$llvm_root"
fi

./install.py --clang-completer; check "run install.py script."

ycmd="$HOME/.vim/bundle/youcompleteme/third_party/ycmd"

if [[ ! -z "$llvm_root" && $(uname) =~ Linux ]]; then
    # For some reason the YCM build does not always create the
    # libclang.so.* symlink properly when we specify a custom
    # llvm root, so we will do it here manually.
    full_version=$($llvm_root/bin/clang --version | sed -n 's/clang version \([0-9\.]\+\).*/\1/p')
    [[ ! -z "$full_version" ]]; check "extract clang full version"
    msg "Found Clang version: $full_version"
    major=$($llvm_root/bin/clang --version | sed -n 's/clang version \([0-9]\+\)\..*/\1/p')
    [[ ! -z "$major" ]]; check "extract llvm major version."
    [[ -d "$ycmd" ]]; check "find ycmd folder."
    symlink="$ycmd/libclang.so.$major"
    rm -f $symlink; check "remove libclang.so.$major symlink"
    ln -s "$llvm_root/lib/libclang.so.$major" "$symlink"
    check "create $symlink symlink"
fi

if [[ ! -z "$llvm_root" ]]; then
    # Now we must link ycm's clang_includes directory to the
    # correct folder within the llvm version being used.  This
    # folder holds system include files.
    clang_includes="$ycmd/clang_includes"
    [[ -e "$clang_includes.bak" ]] && \
        rm -rf "$clang_includes"
    [[ -e "$clang_includes" ]] && \
        mv "$clang_includes" "$clang_includes.bak"
    ln -s "$llvm_root/lib/clang/$full_version" "$clang_includes"
    check "create clang_includes symlink"
fi

msg "Finished building YCM."
