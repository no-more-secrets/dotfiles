function add-gitlab
    set name (git remote show origin | grep 'Fetch URL' | tr '/' ' ' | awk '{ print $NF }' | sed 's/\.git//g')
    if not string length -q $name
        return 1
    end
    git remote add gitlab ssh://git@gitlab.com/dpacbach/$name
end
