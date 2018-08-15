# Allows user to select from ps lines and will output (muliple)
# PIDs that are selected.
function fzf-ps
    set -l ps_lines (ps -fu $USER | fzf --no-preview)

    # Return zero because we have already called fzf and we
    # don't want the caller to pop up another window.
    string length -q $ps_lines; or return 0

    for l in $ps_lines
        # Extract PID from line.  This regex assumes that it
        # is the second column (separated by spaces).
        echo (string replace -r ' *[^ ]+ +([0-9]+).*' '$1' $l)
    end
end
