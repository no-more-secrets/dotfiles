#!bin/bash
# Install fonts in user's home folder and update font cache.
#
# It is assumed that this script will be run with CWD one level
# above the folder containing this script.

source scripts/utils.sh

msg "Updating font cache"

fc-cache -fv; check "update font cache"
