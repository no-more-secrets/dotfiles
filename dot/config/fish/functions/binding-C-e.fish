function binding-C-e
    set -l result (eval $fzf_ctrl_e_cmd | fzf --no-preview --no-multi)

    string length -q $result; and cd $result

    commandline -f repaint
end
