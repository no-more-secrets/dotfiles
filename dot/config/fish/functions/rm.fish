# Re-routes to the recycle command, if it exists.
function rm
    set -l recycle ~/dev/utilities/misc/recycle
    if test -x $recycle
        eval $recycle $argv
    else
        command rm $argv
    end
end
