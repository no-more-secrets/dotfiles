#!/bin/bash
source scripts/utils.sh

# Install or Update Vundle
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    msg 'Installing Vundle...'
    git clone --quiet https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    check 'clone vundle repo'
else
    msg 'Updating Vundle...'
    pushd ~/.vim/bundle/Vundle.vim
    git pull --quiet origin master; check 'update vundle repo'
    popd
fi

# Install or Update Plugins

# Need this because the below apparently will invoke a shell and
# this can cause problems if the current shell is e.g. fish.
export SHELL=/bin/sh

msg 'Installing plugins...'
vim +PluginInstall +qall; check 'install plugins'
msg 'Updating plugins...'
vim +PluginUpdate  +qall; check 'update plugins'
