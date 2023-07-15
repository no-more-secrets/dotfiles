#!/bin/bash
# Install fonts in user's home folder and update font cache.
#
# It is assumed that this script will be run with CWD one level
# above the folder containing this script.

source scripts/utils.sh

if [[ -e ~/.local/share/fonts/"Literation Mono Powerline.ttf" ]]; then
  msg "Powerline fonts already installed."
  exit 0
fi

msg "Installing powerline fonts."

cd /tmp
rm -rf fonts

git clone https://github.com/powerline/fonts
cd fonts

# This should update the font cache, which should then also pick
# up the fonts in the ~/.fonts folder that will now exist after
# the symlinks are set up into the .dotfiles folder.
./install.sh

# Note: to reset the font cache do this:
#fc-cache -fv; check "update font cache"
