# Will pull to origin/<current-branch>
function pull
    set -l name (branch)
    and git pull origin $name
end
