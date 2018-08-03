#!/bin/bash
#!/bin/bash
set -e

cd $(dirname $(readlink -f $0))

profiles="/org/gnome/terminal/legacy/profiles:/"

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

foreground="'$(<foreground.txt)'"
background="'$(<background-matte.txt)'"

dconf write ${full_profile}background-color "$background"
dconf write ${full_profile}foreground-color "$foreground"

echo Success.
