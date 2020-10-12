#!/bin/bash
set -e

sdl_version=2.0-0

list="
    autoconf
    automake
    bison
    build-essential
    cargo
    ccache
    cloc
    cmake
    curl
    dconf-cli
    entr
    exuberant-ctags
    fish
    flex
    fluid-soundfont-gm
    fluidsynth
    git
    htop
    libcurl4-openssl-dev
    libdw-dev
    libfontconfig1-dev
    libfreetype6
    libfreetype6-dev
    libgl1-mesa-dev
    libharfbuzz-dev
    liblua5.3-dev
    libncurses5
    libncurses5-dev
    libncursesw5
    libncursesw5-dev
    libsdl2-$sdl_version
    libsdl2-dev
    libsdl2-doc
    libsdl2-image-$sdl_version
    libsdl2-image-dev
    libsdl2-mixer-$sdl_version
    libsdl2-mixer-dev
    libsdl2-net-$sdl_version
    libsdl2-net-dev
    libsdl2-ttf-$sdl_version
    libsdl2-ttf-dev
    libsqlite3-0
    libsqlite3-dev
    libssl-dev
    libtool
    libtool-bin
    libwebp-dev
    libx11-dev
    libxcb-render0
    libxcb-render0-dev
    libxcb-shape0
    libxcb-shape0-dev
    libxcb-xfixes0
    libxcb-xfixes0-dev
    libxcursor-dev
    libxml2
    libxml2-dev
    lua5.3
    ninja-build
    nmap
    openssh-server
    pax-utils
    perl
    powertop
    protobuf-compiler
    python
    python2.7
    python2.7-dev
    python3
    python3-dev
    python3-pip
    python-pip-whl
    qt5-default
    screenfetch
    silversearcher-ag
    subversion
    tlp
    tmux
    tree
    vim
    wget
    xclip
    zip
"

sudo apt-add-repository -y ppa:system76-dev/stable
sudo apt update

sudo apt install $list

bash scripts/install-fd.sh

bash scripts/install-stack.sh

sudo apt install system76-power
