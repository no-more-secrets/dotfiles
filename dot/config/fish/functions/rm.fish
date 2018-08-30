# Re-routes to the recycle command, if it exists.
function rm
    if test -e ~/bin/recycle
        ~/bin/recycle $argv
    else
        command rm $argv
    end
end
