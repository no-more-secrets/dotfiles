#!/bin/bash
# ╔═════════════════════════════════════════════════════════════╗
# ║                    Dotfiles Setup Script                    ║
# ╚═════════════════════════════════════════════════════════════╝

# Change to Script Folder
script_dir=$(dirname $(readlink -f $0))
cd $script_dir || { echo 'error changing directory.'; exit 1; }

# Run setup scripts
bash scripts/make_links.sh
bash scripts/vundle.sh

# Exit with success
true
