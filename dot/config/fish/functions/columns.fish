# Select (filter) columns from stdin.  Specifying no args will
# print all columns.
function columns
    set -l cols ""
    for c in $argv
        set cols "$cols\$$c,"
    end
    # chop off the last character (,)
    set cols (string sub -s 1 -l (math (string length $cols) - 1) $cols)
    awk "{print $cols}"
end
