# This will show a list of all unique extensions found on all files
# resulting from the `ls` along with their frequencies.
function lsext
    # Use unaliased version of ls.
    command ls $argv | sed -n 's/.*\(\.[^./].*\)$/\1/p' \
                     | sort                             \
                     | uniq -c                          \
                     | sort -nr
end
