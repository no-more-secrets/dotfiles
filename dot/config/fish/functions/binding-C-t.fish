function binding-C-t
    set -l result ""
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and string match -q -r "^[ ]*kill " (commandline)
        set result (fzf-kill); set handled $status
    end

    if [ ! $handled -eq 0 ]; and string match -q -r "^[ ]*pstree " (commandline)
        set result (fzf-pstree); set handled $status
    end

    if [ ! $handled -eq 0 ]; and functions -q local-binding-C-t
        set result (local-binding-C-t); set handled $status
    end

    # Last resort
    if [ ! $handled -eq 0 ]
        set result (fzf --preview='head -n40 {}'); set handled $status
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
