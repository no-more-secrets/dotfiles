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

if [[ -e "$llvm_root" ]]; then
    full_version=$($llvm_root/bin/clang --version | sed -n 's/clang version \([0-9\.]*\).*/\1/p')
    [[ ! -z "$full_version" ]]; check "extract clang full version"
    msg "Found Clang version: $full_version"

    if [[ $(uname) =~ Linux ]]; then
        # For some reason the YCM build does not always create
        # the libclang.so.* symlink properly when we specify a
        # custom llvm root, so we will do it here manually.
        major=$($llvm_root/bin/clang --version | sed -n 's/clang version \([0-9]\+\)\..*/\1/p')
        [[ ! -z "$major" ]]; check "extract llvm major version."
        [[ -d "$ycmd" ]]; check "find ycmd folder."
        symlink="$ycmd/libclang.so.$major"
        rm -f $symlink; check "remove libclang.so.$major symlink"
        ln -s "$llvm_root/lib/libclang.so.$major" "$symlink"
        check "create $symlink symlink"
    fi

    # Now we must link ycm's clang_includes directory to the
    # correct folder within the llvm version being used.  This
    # folder holds system include files.
    clang_includes="$ycmd/clang_includes"
    [[ -e "$clang_includes.bak" ]] && \
        rm -rf "$clang_includes"
    [[ -e "$clang_includes" ]] && \
        mv "$clang_includes" "$clang_includes.bak"
    includes_location="$llvm_root/lib/clang/$full_version"
    ln -s "$includes_location" "$clang_includes"
    check "create clang_includes symlink"
    # We need to create another link to the same place but from
    # yet another folder as this is the one that is used as the
    # "resource-dir".
    clang_link_dir="$ycmd/third_party/clang/lib/clang"
    # Should already be present from the YCM rebuilding process
    # (with at least one link inside of it), but just in case.
    mkdir -p "$clang_link_dir"; check "make clang link dir 1"
    # First remove the parent folder to get rid of any previous
    # links/folders in there because those will cause trouble for
    # YCM (it seems to pick up the first one that it finds, even
    # if it's the wrong version).
    rm -rf "$clang_link_dir"; check "remove clang link dir"
    mkdir "$clang_link_dir"; check "make clang link dir 2"
    # Now create the link.
    version_link="$clang_link_dir/$full_version"
    ln -s "$includes_location" "$version_link"
    check "create includes version symlink"
fi

msg "Finished building YCM."
