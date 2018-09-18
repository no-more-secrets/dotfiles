# Run ag with arguments that make its output suitable for piping into fzf.
function ag-for-fzf
    ag --color --column --nogroup $argv
end
