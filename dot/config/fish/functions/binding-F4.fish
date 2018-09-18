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
        read -P 'search> ' line
        set result (ag-for-fzf $line | fzf)
    end

    repaint-cmd-line ""

    set -l file (string replace -r '^([^:]+):.*' '${1}' $result)
    or return 1
    set -l line (string replace -r '^[^:]+:([0-9]+):.*' '${1}' $result)
    or return 1

    if string match -q $argv[1] "shift"
        # Change to the directory containing the file and adjust the
        # file name accordingly.
        cd $dir (dirname $file)
        set file (basename $file)
    end

    repaint-cmd-line "vim +$line $file"
end
