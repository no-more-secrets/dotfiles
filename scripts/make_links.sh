#!/bin/bash
# Must be run from dotfiles root folder.
unalias -a

# ╔═════════════════════════════════════════════════════════════╗
# ║                          Utilities                          ║
# ╚═════════════════════════════════════════════════════════════╝
green='\e[32m'
normal='\e[00m'

error() {
    echo "ERROR: $1" >&2
    exit 1
}

check() {
    error_code=$?
    local msg="$1"
    [[ $error_code != 0 ]] && error "failed to $msg"
    echo "succeeded to $msg"
}

# ╔═════════════════════════════════════════════════════════════╗
# ║                       Symlink Creator                       ║
# ╚═════════════════════════════════════════════════════════════╝
safe_link() {
    # src --> target
    local target="$(pwd)/dot/$1"
    local src="$HOME/.$1"
    if [[ ! -e "$src" ]]; then
        # At this point the file does not exist, however we  will
        # run a forced remove on it anyway because it could be  a
        # broken  link  (which  will be reported as a nonexistent
        # file)  which  we want to remove. We need the -f just in
        # case it really doesn't exist  --  in that case it would
        # emit errors to stderr  which  we  don't want. Note that
        # this command should never return  non-zero,  but  we'll
        # check for it anyway.
        rm -f "$src"; check "remove possible link"
    else
        # Source file exists
        [[ ! -L "$src" ]] && {
            # Source file exists and  is  not  a  link,  so to be
            # safe, let's just exit with an error.
            error "file $src already exists and is not a link."
        }
        # Source file exists and is  a  link,  so remove the link
        # and proceed.
        rm "$src"; check "remove $src"
    fi
    ln -s "$target" "$src"; check "create link $src"
}

# ╔═════════════════════════════════════════════════════════════╗
# ║                           Driver                            ║
# ╚═════════════════════════════════════════════════════════════╝
main() {
    echo -e "${green}Making symlinks...${normal}"

    list='
        bashrc
        ghc
        gitconfig
        vim
        vimrc
        tmux.conf
        tmux
    '

    for f in $list; do safe_link $f; done
}

main
