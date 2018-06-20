# List all links in the current folder and display source and target
# with an "arrow" in between in an aligned table format.
function links 
    find . -maxdepth 1 -type l | sed 's/^\.\///' | xargs -n10000 ls -l | awk '{print $9, $10, $11}' | column -t | grep '[-]>'
end
