#!/bin/bash
set -e

cd $(dirname $(readlink -f $0))

profiles="/org/gnome/terminal/legacy/profiles:/"

echo
echo "Go into the gnome-terminal preferences and create a"
echo "new profile called dsicilia.  Then press enter to continue..."
read

profile_id=$(dconf list $profiles | grep '^:')
echo "List of profiles:"
echo "$profile_id"

[[ ! -z "$profile_id"         ]]
[[ "$profile_id" =~ :[^:]{36} ]]

full_profile="$profiles$profile_id"

echo "Full profile:"
echo "$full_profile"

settings=$(dconf list $full_profile)
echo "List of settings:"
echo "$settings"

foreground="'$(./to-hex.sh $(<foreground.txt))'"
background="'$(./to-hex.sh $(<background.txt))'"

dconf write "${full_profile}background-color" "$background"
dconf write "${full_profile}foreground-color" "$foreground"

echo Success.
