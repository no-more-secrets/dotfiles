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

    repaint-cmd-line (file-lineno-to-vim $result)
end
