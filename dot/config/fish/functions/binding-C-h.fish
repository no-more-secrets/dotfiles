function binding-C-h
    set -l result ""
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and git rev-parse --is-inside-work-tree 1>/dev/null 2>/dev/null
        # Simply-parsable list of relative paths (relative to CWD), ignoring
        # with no renames + ignoring deleted files (so therefore if a file is
        # renamed the new name will appear in the list).  Ideally we would put
        # the --no-renames flag here because it is required for proper handling
        # of renamed files, but not all git versions support it.
        set result (git status --short | grep -v '^D' | awk '{print $2}' | fzf -0 --preview='head -n40 {}'); set handled $status
        if string length -q $result
            git diff $result
        end
    end

    if [ ! $handled -eq 0 ]; and functions -q local-binding-C-h
        set result (local-binding-C-h); set handled $status
    end
    
    repaint-cmd-line
end
