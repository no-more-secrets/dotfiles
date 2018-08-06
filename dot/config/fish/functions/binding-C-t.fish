function binding-C-t
    set -l result ""

    if string match -q -r "^[ ]*kill " (commandline)
        set result (fzf-kill)
        repaint-cmd-line $result
        return
    end

    if functions -q local-binding-C-t
        set result (local-binding-C-t); and begin
            repaint-cmd-line $result
            return
        end
    end

    # Last resort
    set result (fzf)

    repaint-cmd-line $result
end
