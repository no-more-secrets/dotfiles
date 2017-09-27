#!/bin/bash
unalias -a

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

safe_link() {
    # src --> target
    local target="$(pwd)/$1"; local src="$HOME/$2"
    [[ -e "$src" ]] && {
        # Source file exists
        [[ ! -L "$src" ]] && {
            # Source file exists and is not a link, so to be safe,
            # let's just exit with an error.
            error "file $src already exists and is not a link."
        }
        # Source file exists and is a link, so remove the link and proceed.
        rm "$src"; check "remove $src"
    }
    ln -s "$target" "$src"; check "create link $src"
}

safe_link  dot-bashrc               .bashrc
safe_link  dot-ghc-slash-ghci.conf  .ghc/ghci.conf
safe_link  dot-gitconfig            .gitconfig
safe_link  dot-ssh-slash-config     .ssh/config
safe_link  dot-vim-folder           .vim
safe_link  dot-vimrc                .vimrc
safe_link  dot-tmux-conf            .tmux.conf
safe_link  dot-tmux-folder          .tmux
true
