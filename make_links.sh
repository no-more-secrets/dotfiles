#!/bin/bash
rm $HOME/.bashrc
ln -s $(pwd)/dot-bashrc $HOME/.bashrc
rm $HOME/.ghc/ghci.conf
ln -s $(pwd)/dot-ghc-slash-ghci.conf $HOME/.ghc/ghci.conf
rm $HOME/.gitconfig
ln -s $(pwd)/dot-gitconfig $HOME/.gitconfig
rm -rf $HOME/.vim
ln -s $(pwd)/dot-vim-folder $HOME/.vim
rm $HOME/.vimrc
ln -s $(pwd)/dot-vimrc $HOME/.vimrc
