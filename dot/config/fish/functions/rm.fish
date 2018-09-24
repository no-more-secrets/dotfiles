# Re-routes to the recycle command, if it exists.
function rm
    if test -x ~/dev/utilities/misc/recycle
        ~/dev/utilities/misc/recycle $argv
    else
        command rm $argv
    end
end
