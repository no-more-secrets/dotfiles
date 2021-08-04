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
    htop
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
    libxft-dev
    libxml2
    libxml2-dev
    linux-tools-generic
    lua5.3
    ncal
    ninja-build
    nmap
    openssh-server
    pax-utils
    perl
    powertop
    protobuf-compiler
    pulsemixer
    python
    python2.7
    python2.7-dev
    python3
    python3-dev
    python3-pip
    python-pip-whl
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

if ! which gcert &>/dev/null; then
  sudo apt-add-repository -y ppa:system76-dev/stable
fi
sudo apt update

sudo apt install $list

export PATH=~/.local/bin:$PATH
bash scripts/install-stack.sh

if ! which gcert &>/dev/null; then
  sudo apt install system76-power
fi

rm -f ~/bin/bat
ln -s "$(which batcat)" ~/bin/bat

pip3 install --user \
  spotipy  # For the spotify playlist sync script.
