#!/bin/bash

######################################################################
# @author      : dsicilia (dsicilia@$HOSTNAME)
# @file        : install-stack
# @created     : Saturday Sep 08, 2018 11:07:34 EDT
#
# @description : 
######################################################################
set -e
set -o pipefail

source scripts/utils.sh

if which stack 2>/dev/null; then
    msg 'Upgrading haskell-stack...'
    stack upgrade # sudo?
else
    msg 'Installing haskell-stack...'
    curl -sSL https://get.haskellstack.org/ | sh
fi
