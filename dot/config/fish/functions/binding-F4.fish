# Runs AG-like utilities to search, piping output through fzf, then taking
# the result of that and constructing a `vim` command that will open the
# selected file to the line number containing the search result.
function binding-F4
    set -l result ""
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and functions -q local-binding-F4
        set result (local-binding-F4); set handled $status
    end

    # Last resort
    if [ ! $handled -eq 0 ]
        set -l ag_color (set_color aa3333)
        set -l ag "ag"
        set -l normal_color (set_color normal)
        read -P "$ag_color$ag$normal_color: " line
        if string length -q $line
            set result (ag-for-fzf $line | fzf)
        end
    end

    repaint-cmd-line ""
    set -l file
    set -l line

    if string match -qr ':' $result
        set file (string replace -r '^([^:]+):.*' '${1}' $result)
        or return 1
        set line (string replace -r '^[^:]+:([0-9]+):.*' '${1}' $result)
        or return 1
    else
        set file $result
        set line
    end

    if string match -q $argv[1] "shift"
        # Change to the directory containing the file and adjust the
        # file name accordingly.
        cd $dir (dirname $file)
        set file (basename $file)
    end

    if string length -q $line
        repaint-cmd-line "vim +$line $file"
    else
        repaint-cmd-line "vim $file"
    end
end
