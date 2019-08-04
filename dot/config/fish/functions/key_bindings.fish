# Use the fish_key_reader command to get escape codes and/or bind
# statement for a given key press. Some of escape codes in this
# file were found on a particular machine using that utility.
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

    bind \ck binding-C-k
    if bind -M insert > /dev/null 2>&1
        bind -M insert \ck binding-C-k
    end

    # F3
    bind -k f3 'binding-F3'
    if bind -M insert > /dev/null 2>&1
        bind -M insert -k f3 'binding-F3'
    end

    # F4
    bind -k f4 'binding-F4'
    if bind -M insert > /dev/null 2>&1
        bind -M insert -k f4 'binding-F4'
    end

    # Shift-F4
    bind \e\[1\;2S 'binding-F4 shift'
    if bind -M insert > /dev/null 2>&1
        bind -M insert \e\[1\;2S 'binding-F4 shift'
    end

    # F5
    bind -k f5 'binding-F5'
    if bind -M insert > /dev/null 2>&1
        bind -M insert -k f5 'binding-F5'
    end

    # Shift-F5
    bind \e\[15\;2~ 'binding-F5 shift'
    if bind -M insert > /dev/null 2>&1
        bind -M insert \e\[15\;2~ 'binding-F5 shift'
    end

    # F6
    bind -k f6 'binding-F6'
    if bind -M insert > /dev/null 2>&1
        bind -M insert -k f6 'binding-F6'
    end

    # Shift-F6
    bind \e\[17\;2~ 'binding-F6 shift'
    if bind -M insert > /dev/null 2>&1
        bind -M insert \e\[17\;2~ 'binding-F6 shift'
    end

    # F8
    bind -k f8 'binding-F8'
    if bind -M insert > /dev/null 2>&1
        bind -M insert -k f8 'binding-F8'
    end

    # F9
    bind -k f9 'binding-F9'
    if bind -M insert > /dev/null 2>&1
        bind -M insert -k f9 'binding-F9'
    end
end
