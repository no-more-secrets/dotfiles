#!/bin/bash
set -e
set -o pipefail

cd ~/dev
[[ ! -d suckless ]] && git clone ssh://git@github.com/dpacbach/suckless

cd ~/dev/suckless
make

./dwm/install.sh