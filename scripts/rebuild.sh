#!bin/bash
# Does any rebuilding and/or updating of components that must
# in general be done after updating versions.
#
# It is assumed that this script will be run with CWD one level
# above the folder containing this script.

source scripts/utils.sh

[[ "$HOME" =~ oo ]] || {
  # Don't do this in work environment.
  msg "Rebuilding YCM"
  bash scripts/build-ycm.sh; check "build ycm"
}

msg "Updating FZF"
bash scripts/update-fzf.sh; check "update fzf"
