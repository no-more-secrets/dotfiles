function key_bindings
    bind \ce binding-C-e
    if bind -M insert > /dev/null 2>&1
      bind -M insert \ce binding-C-e
    end

    bind \cg binding-C-g
    if bind -M insert > /dev/null 2>&1
        bind -M insert \cg binding-C-g
    end

    if functions -q fzf-C-t
        bind \ct fzf-C-t
        if bind -M insert > /dev/null 2>&1
            bind -M insert \ct fzf-C-t
        end
    end

    bind \cp binding-C-p
    if bind -M insert > /dev/null 2>&1
        bind -M insert \cp binding-C-p
    end
end
