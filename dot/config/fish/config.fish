function my_vi_bindings
    fish_vi_key_bindings
    # This will allow us to retain the default fish C-F (accept suggestion)
    # feature when VI mode is enabled.
    bind -M insert  \cf forward-char
    bind -M default \cf forward-char
    bind -M visual  \cf forward-char
end

set -g fish_key_bindings my_vi_bindings
#set -g fish_key_bindings fish_vi_key_bindings
