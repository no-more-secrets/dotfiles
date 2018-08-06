function binding-C-t
    set -l result ""
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and string match -q -r "^[ ]*kill " (commandline)
        set result (fzf-kill); set handled $status
    end

    if [ ! $handled -eq 0 ]; and functions -q local-binding-C-t
        set result (local-binding-C-t); set handled $status
    end

    # Last resort
    if [ ! $handled -eq 0 ]
        set result (fzf); set handled $status
    end

    # If the commandline is empty and the file is not executable then
    # then put a `vim` in front of it because# we will likely want to
    # edit the result.
    if string length -q $result; and not string length -q (commandline); and [ ! -x $result ]
        set result vim $result
    end

    repaint-cmd-line $result
end
