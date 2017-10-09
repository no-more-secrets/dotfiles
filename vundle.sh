#!/bin/bash
set -e
set -x
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    echo 'Installing Vundle...'
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    echo 'Updating Vundle...'
    pushd ~/.vim/bundle/Vundle.vim
    git pull origin master
    popd
fi
echo 'Installing plugins...'
vim +PluginInstall +qall
echo 'Updating plugins...'
vim +PluginUpdate  +qall
echo 'Finished.'
