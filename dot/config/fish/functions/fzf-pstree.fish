# Handler that will be called for Ctrl-t autocomplete after
# a pstree command.  Note that this won't test to see if there
# is a pstree command on the command line -- that fact should
# already have been established before this call.
function fzf-pstree
    # pstree doesn't seem to support multiple PIDs.
    set -l ps_line (ps -fu $USER | fzf --no-preview --no-multi)

    # Return zero because we have already called fzf and we
    # don't want the caller to pop up another window.
    string length -q $ps_line; or return 0

    # Extract PID from line.  This regex assumes that it
    # is the second column (separated by spaces).
    echo (string replace -r ' *[^ ]+ +([0-9]+).*' '$1' $ps_line)
end
