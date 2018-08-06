function binding-C-e
    set -l result ""
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and functions -q local-binding-C-e
        set result (local-binding-C-e); set handled $status
    end

    if [ ! $handled -eq 0 ]
        set result (eval $fzf_ctrl_e_cmd 2>/dev/null | fzf --no-preview --no-multi)
    end

    string length -q $result; and cd $result

    commandline -f repaint
end
