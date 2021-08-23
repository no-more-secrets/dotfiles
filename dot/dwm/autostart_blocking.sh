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

battery_percentage() {
  which upower &>/dev/null || return
  local dev=$(upower -e 2>/dev/null | grep BAT)
  [[ -z "$dev" ]] && {
    echo '??'
    return 0
  }
  local percentage=$(upower -i $dev 2>/dev/null | awk '/percentage/ { print $2 }' | tr -d '%')
  echo "$percentage"
  return 0
}

status_bar() {
  while true; do
    local date="$(date +"%A, %b %d, %Y")"
    local time="$(date +"%I:%M %p")"
    local battery="Bat: $(battery_percentage)%"
    local bar="$date | $time | $battery"
    xsetroot -name "$bar"
    sleep 10
  done
}

status_bar &