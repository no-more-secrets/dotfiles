# Handler that will be called for Ctrl-t autocomplete after
# a kill command.  Note that this won't test to see if there
# is a kill command on the command line -- that fact should
# already have been established before this call.
function fzf-kill
    ps-fzf
end
