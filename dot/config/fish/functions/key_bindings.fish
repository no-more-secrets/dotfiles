function key_bindings
    bind \ce binding-C-e
    if bind -M insert > /dev/null 2>&1
      bind -M insert \ce binding-C-e
    end

    bind \cg binding-C-g
    if bind -M insert > /dev/null 2>&1
        bind -M insert \cg binding-C-g
    end

    bind \ct binding-C-t
    if bind -M insert > /dev/null 2>&1
        bind -M insert \ct binding-C-t
    end

    bind \cp binding-C-p
    if bind -M insert > /dev/null 2>&1
        bind -M insert \cp binding-C-p
    end
end
