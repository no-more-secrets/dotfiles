function binding-C-p
    set -l result ""
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and git rev-parse --is-inside-work-tree 1>/dev/null 2>/dev/null
        # Simply-parsable list of relative paths (relative to CWD), ignoring
        # with no renames + ignoring deleted files (so therefore if a file is
        # renamed the new name will appear in the list).  Ideally we would put
        # the --no-renames flag here because it is required for proper handling
        # of renamed files, but not all git versions support it.
        set result (git status --short | grep -v '^D' | awk '{print $2}' | fzf -0 --preview='head -n40 {}'); set handled $status
    end

    if [ ! $handled -eq 0 ]; and functions -q local-binding-C-p
        set result (local-binding-C-p); set handled $status
    end

    # If there is a result then we might want to manipulate the commandline
    # apart from just tacking the result onto the end.
    if string length -q $result
        if not string length -q (commandline); and [ ! -x $result ]
            # If the commandline is empty and the file is not executable then
            # then put a `vim` in front of it because# we will likely want to
            # edit the result.
            set result vim $result
        end
        if string match -q -r "^[ ]*cd " (commandline)
            # If the user has a `cd` then they probably want to change to the
            # directory of the selected file.
           commandline -r ""
           cd (dirname $result)
            set result ""
        end
    end

    repaint-cmd-line $result
end
