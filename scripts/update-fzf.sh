#!/bin/bash
# Installs and/or updates fzf (the command-line tool, not the vim plugin).
#
# This script is expected to run with CWD one level above.

source scripts/utils.sh

[[ -d ~/.fzf ]] || {
    # Needs to be installed initially.
    msg "fzf not installed -- installing..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    exit $?
}

msg "fzf found...updating..."

cd ~/.fzf
git pull && ./install --all
