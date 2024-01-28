#!/bin/bash
set -e

sdl_version=2.0-0

list="
    autoconf
    automake
    bat
    bison
    build-essential
    cargo
    ccache
    cloc
    cmake
    compton
    curl
    dconf-cli
    dconf-editor
    entr
    exa
    exuberant-ctags
    fd-find
    feh
    fish
    flex
    fluid-soundfont-gm
    fluidsynth
    git
    gpick
    haskell-stack
    htop
    iw
    libcurl4-openssl-dev
    libdw-dev
    libevent-dev
    libfontconfig1-dev
    libfreetype6
    libfreetype6-dev
    libgl1-mesa-dev
    libharfbuzz-dev
    liblua5.4-dev
    libncurses5
    libncurses5-dev
    libncursesw5
    libncursesw5-dev
    libsdl2-$sdl_version
    libsdl2-dev
    libsdl2-doc
    libsdl2-mixer-$sdl_version
    libsdl2-mixer-dev
    libsdl2-net-$sdl_version
    libsdl2-net-dev
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
    libxft-dev
    libxml2
    libxml2-dev
    light
    lua5.4
    lua-posix
    luarocks
    ncal
    ncdu
    ninja-build
    nmap
    openssh-server
    pax-utils
    perl
    powertop
    protobuf-compiler
    pulsemixer
    python3
    python3-dev
    python3-pip
    python-is-python3
    qt5-qmake
    qtbase5-dev
    qtbase5-dev-tools
    qtchooser
    re2c
    ripgrep
    screenfetch
    silversearcher-ag
    subversion
    tigervnc-common
    tigervnc-viewer
    tlp
    tmux
    tree
    vim
    wget
    xclip
    xdotool
    zip
"

sudo apt-add-repository -y ppa:system76-dev/stable

sudo apt update
sudo apt install $list --yes

# ---------------------------------------------------------------
# Lua
# ---------------------------------------------------------------
rocks="
    luaposix
    lunajson
"

luarocks config lua_version 5.4

for rock in $rocks; do
    echo "installing luarock: $rock"
    luarocks install "$rock" --local
done

# ---------------------------------------------------------------
# Python
# ---------------------------------------------------------------
pip3 install --user \
  spotipy  # For the spotify playlist sync script.
