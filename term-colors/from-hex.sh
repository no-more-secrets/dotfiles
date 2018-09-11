#!/bin/bash
# Convert a hex color "235467" or "#235467" to nearest 0-255 color index.
# Taken from:
#   https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes

from_hex(){
    local hex=$1
    # Must look like "1a2b3c" or "#1A2B3c", etc.
    local regex='^#?([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})$'
    [[ "$hex" =~ $regex ]] || return 1
    local r=$(( 16#${BASH_REMATCH[1]} ))
    local g=$(( 16#${BASH_REMATCH[2]} ))
    local b=$(( 16#${BASH_REMATCH[3]} ))
    printf '%03d' "$(( (r<35?0:(r-35)/40)*6*6 +
                       (g<35?0:(g-35)/40)*6   +
                       (b<35?0:(b-35)/40)     + 16 ))"
}

from_hex $1
