#!/bin/bash
# ╔═════════════════════════════════════════════════════════════╗
# ║                    Dotfiles Setup Script                    ║
# ╚═════════════════════════════════════════════════════════════╝
source scripts/utils.sh
msg 'Setting up environment...'

# Run setup scripts
bash scripts/make_links.sh; check 'make symlinks'

msg 'Sourcing new .bashrc...'
# Now  that  we  probably  have a new bashrc file let's source it
# since we will need some of the settings in there for subsequent
# commands.
source ~/.bashrc; check 'source new .bashrc'

# Install all the vim plugins.
bash scripts/vundle.sh; check 'setup vundle'

# Exit with success
true
