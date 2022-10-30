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
    liblua5.3-dev
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
    lua5.3
    lua-posix
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
    python-pip-whl
    qt5-qmake
    qtbase5-dev
    qtbase5-dev-tools
    qtchooser
    re2c
    screenfetch
    silversearcher-ag
    subversion
    tigervnc-common
    tlp
    tmux
    tree
    vim
    wget
    xclip
    zip
"

if ! which gcert &>/dev/null; then
  sudo apt-add-repository -y ppa:system76-dev/stable
fi
sudo apt update

sudo apt install $list --yes

if ! which gcert &>/dev/null; then
  sudo apt install system76-power --yes
fi

rm -f ~/bin/bat
ln -s "$(which batcat)" ~/bin/bat

pip3 install --user \
  spotipy  # For the spotify playlist sync script.
