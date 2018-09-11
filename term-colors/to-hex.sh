#!/bin/bash
# Converts a 0-255 color index to its hex value.
# Taken from:
#   https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes

to_hex() {
    dec=$(($1%256))   ### input must be a number in range 0-255.
    if [ "$dec" -lt "16" ]; then
        bas=$(( dec%16 ))
        mul=128
        [ "$bas" -eq "7" ] && mul=192
        [ "$bas" -eq "8" ] && bas=7
        [ "$bas" -gt "8" ] && mul=255
        a="$((  (bas&1)    *mul ))"
        b="$(( ((bas&2)>>1)*mul ))" 
        c="$(( ((bas&4)>>2)*mul ))"
        printf '#%02x%02x%02x\n' "$a" "$b" "$c"
    elif [ "$dec" -gt 15 ] && [ "$dec" -lt 232 ]; then
        b=$(( (dec-16)%6  )); b=$(( b==0?0: b*40 + 55 ))
        g=$(( (dec-16)/6%6)); g=$(( g==0?0: g*40 + 55 ))
        r=$(( (dec-16)/36 )); r=$(( r==0?0: r*40 + 55 ))
        printf '#%02x%02x%02x\n' "$r" "$g" "$b"
    else
        gray=$(( (dec-232)*10+8 ))
        printf '#%02x%02x%02x\n' "$gray" "$gray" "$gray"
    fi
}

to_hex $1
