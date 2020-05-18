# List all installed packages.
function installed
  apt list --installed 2>/dev/null | sed -r 's/\/.*//g' | grep -v 'Listing\.\.' | fzf
end