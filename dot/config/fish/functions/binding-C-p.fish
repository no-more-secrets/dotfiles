function binding-C-p
    set -l result ""
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and git rev-parse --is-inside-work-tree 1>/dev/null 2>/dev/null
        # Simply-parsable list of relative paths (relative to CWD), ignoring
        # with no renames + ignoring deleted files (so therefore if a file is
        # renamed the new name will appear in the list).
        set result (git status --short --no-renames | grep -v '^D' | awk '{print $2}' | fzf -0 --preview='head -n40 {}'); set handled $status
    end

    if [ ! $handled -eq 0 ]; and functions -q local-binding-C-p
        set result (local-binding-C-p); set handled $status
    end

    # If the commandline is empty and the file is not executable then
    # then put a `vim` in front of it because# we will likely want to
    # edit the result.
    if string length -q $result; and not string length -q (commandline); and [ ! -x $result ]
        set result vim $result
    end

    repaint-cmd-line $result
end
