#!/bin/bash
# ╔═════════════════════════════════════════════════════════════╗
# ║                          Utilities                          ║
# ╚═════════════════════════════════════════════════════════════╝
set -e
set -x

msg() {
    green="\e[32m"
    normal="\e[00m"
    echo -e "${green}$1${normal}"
}

# ╔═════════════════════════════════════════════════════════════╗
# ║                  Install or Update Vundle                   ║
# ╚═════════════════════════════════════════════════════════════╝
if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
    echo 'Installing Vundle...'
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    echo 'Updating Vundle...'
    pushd ~/.vim/bundle/Vundle.vim
    git pull origin master
    popd
fi

# ╔═════════════════════════════════════════════════════════════╗
# ║                  Install or Update Plugins                  ║
# ╚═════════════════════════════════════════════════════════════╝
msg 'Installing plugins...'
vim +PluginInstall +qall
msg 'Updating plugins...'
vim +PluginUpdate  +qall
msg 'Finished.'
