function binding-C-s
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and functions -q local-binding-C-s
        local-binding-C-s; set handled $status
    end

    if [ ! $handled -eq 0 ]; and git rev-parse --is-inside-work-tree 1>/dev/null 2>/dev/null
        echo 'git st'
        git status
    end

    repaint-cmd-line ""
end
