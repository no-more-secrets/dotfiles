#!/bin/bash
# ╔═════════════════════════════════════════════════════════════╗
# ║                          Utilities                          ║
# ╚═════════════════════════════════════════════════════════════╝
error() {
    echo "ERROR: $1" >&2
    exit 1
}

check() {
    error_code=$?
    local msg="$1"
    [[ $error_code != 0 ]] && error "failed to $msg"
    echo "succeeded to $msg"
}

msg() {
    green="$(tput setaf 3)"
    normal="$(tput sgr0)"
    echo -e "${green}$1${normal}"
}
