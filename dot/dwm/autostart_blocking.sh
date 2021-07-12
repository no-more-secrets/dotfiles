#!/bin/bash
# WARNING: dwm will run this in a blocking way on startup,
#          so any programs that need to stay alive will need
#          to be run in the background using &.
set -o pipefail

# May not be necessary.
xrdb --merge .Xresources

bash ~/dev/utilities/kb/remap-caps.sh
bash ~/dev/utilities/kb/set-repeat-rate.sh