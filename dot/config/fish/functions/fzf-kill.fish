# Handler that will be called for Ctrl-t autocomplete after
# a kill command.  Note that this won't test to see if there
# is a kill command on the command line -- that fact should
# already have been established before this call.
function fzf-kill
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
