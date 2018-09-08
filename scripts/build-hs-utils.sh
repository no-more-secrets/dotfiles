#!/bin/bash

######################################################################
# @author      : dsicilia (dsicilia@$HOSTNAME)
# @file        : build-hs-utils
# @created     : Saturday Sep 08, 2018 11:27:35 EDT
#
# @description : 
######################################################################

set -e
set -o pipefail

source scripts/utils.sh

cd ~/dev/haskell/sfmt

stack setup

msg 'Building sfmt...'
make
