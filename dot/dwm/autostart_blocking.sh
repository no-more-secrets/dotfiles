#!/bin/bash
# WARNING: dwm will run this in a blocking way on startup,
#          so any programs that need to stay alive will need
#          to be run in the background using &.
set -o pipefail

# May not be necessary.
# xrdb -merge ~/.Xresources

bash ~/dev/utilities/kb/remap-caps.sh
bash ~/dev/utilities/kb/set-repeat-rate.sh

# This should not be blocking.
[[ -f ~/.fehbg ]] && bash ~/.fehbg

# This is needed to kill previous status bar runners when we
# restart dwm.
pids="$(pgrep -f 'bash ./autostart_blocking.sh')"
for pid in $pids; do
  # Don't kill ourselves.
  (( $$ == pid )) && continue
  kill $pid
done

status_bar() {
  while true; do
    bar="$(date +"%A, %b %d, %Y | %r")"
    xsetroot -name "$bar"
    sleep 1
  done
}

status_bar &