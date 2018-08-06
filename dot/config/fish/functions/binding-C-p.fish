function binding-C-p
    set -l result ""

    if git rev-parse --is-inside-work-tree 2>/dev/null
        # Simply-parsable list of relative paths (relative to CWD), ignoring
        # with no renames + ignoring deleted files (so therefore if a file is
        # renamed the new name will appear in the list).
        set result (git status --short --no-renames | grep -v '^D' | awk '{print $2}' | fzf)
    else if functions -q local-binding-C-p
        set result (local-binding-C-p)
    end

    # If the commandline is empty then put a `vim` in front of it because
    # we will likely want to edit the result.
    if string length -q $result; and not string length -q (commandline)
        set result vim $result
    end

    repaint-cmd-line $result
end
