# Will push to origin/<current-branch>
function push
    set -l name (branch)
    and git push origin $name
end
