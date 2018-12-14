#!/bin/bash
set -e

# missing: ack, haskell-stack (caused some conflict once)

sdl_version=2.0-0

list="
    autoconf
    automake
    bison
    build-essential
    ccache
    cloc
    cmake
    curl
    dconf-cli
    entr
    exuberant-ctags
    fish
    flex
    git
    htop
    libdw-dev
    libncurses5
    libncurses5-dev
    libncursesw5
    libncursesw5-dev
    libsdl2-dev
    libsdl2-doc
    libsdl2-image-dev
    libsdl2-image-$sdl_version
    libsdl2-mixer-dev
    libsdl2-mixer-$sdl_version
    libsdl2-net-dev
    libsdl2-net-$sdl_version
    libsdl2-$sdl_version
    libsdl2-ttf-dev
    libsdl2-ttf-$sdl_version
    libsqlite3-0
    libsqlite3-dev
    libxml2
    libxml2-dev
    libzip4
    libzip-dev
    ninja-build
    openssh-server
    pax-utils
    perl
    powertop
    python2.7
    python2.7-dev
    python3
    python3-dev
    screenfetch
    silversearcher-ag
    subversion
    tlp
    tmux
    tree
    vim
    wget
    zip
"

sudo apt install $list

bash scripts/install-fd.sh

bash scripts/install-stack.sh
