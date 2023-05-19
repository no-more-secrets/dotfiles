#!bin/bash
# Does any rebuilding and/or updating of components that must
# in general be done after updating versions.
#
# It is assumed that this script will be run with CWD one level
# above the folder containing this script.

source scripts/utils.sh

msg "Updating FZF"
bash scripts/update-fzf.sh; check "update fzf"
