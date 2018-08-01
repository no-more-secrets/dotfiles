function my_vi_bindings
    fish_vi_key_bindings
    # This will allow us to retain the default fish C-F (accept suggestion)
    # feature when VI mode is enabled.
    bind -M insert  \cf forward-char
    bind -M default \cf forward-char
    bind -M visual  \cf forward-char
end

set fish_function_path $fish_function_path ~/.config/fish/functions/local

set -g fish_key_bindings my_vi_bindings
#set -g fish_key_bindings fish_vi_key_bindings

alias t="tree -A -C"

set -l fish_local_config ~/.config/fish/local-config.fish

set PATH $PATH ~/bin

set -gx FZF_DEFAULT_OPTS "--height 30% --reverse --multi"

if test -e $fish_local_config
    source $fish_local_config
end
