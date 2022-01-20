# Displays the current branch name (only -- no asterisk) of the
# local repo.
function branch
    set -l name (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    and echo $name
    # !! Will propagate error code if git command failed.
end
