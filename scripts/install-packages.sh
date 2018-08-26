#!/bin/bash

# missing: fzf, fd, ack, haskell-stack (caused some conflict once)

list="
    autoconf
    automake
    bison
    build-essential
    cloc
    cmake
    curl
    exuberant-ctags
    fish
    flex
    fonts-liberation
    git
    htop
    libncurses5
    libncurses5-dev
    libncursesw5
    libncursesw5-dev
    libsqlite3-0
    libsqlite3-dev
    libxml2
    libxml2-dev
    libzip4
    libzip-dev
    perl
    python2.7
    python2.7-dev
    python3
    python3-dev
    silversearcher-ag
    tmux
    vim
    wget
    xxd
    zip
"

sudo apt install $list
