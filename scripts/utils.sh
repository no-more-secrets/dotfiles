#!/bin/bash
# ╔═════════════════════════════════════════════════════════════╗
# ║                          Utilities                          ║
# ╚═════════════════════════════════════════════════════════════╝
green='\e[32m'
normal='\e[00m'

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
    green="\e[32m"
    normal="\e[00m"
    echo -e "${green}$1${normal}"
}
