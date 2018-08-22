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

set PATH ~/bin ~/.local/bin $PATH

set -gx FZF_DEFAULT_OPTS "
    --height 30%
    --reverse
    --multi
    --select-1
    --preview-window=right:45%"

# If we have fd then use it as the fzf search command.
if which fd >/dev/null 2>&1
    set -l fd_cmd 'fd -HI -E .git'
    # May include some symlinks which are not folders.  Oh well.
    #set -l fd_dirs_cmd 'fd -HI --type d --type l -E .git'
    set -l fd_dirs_cmd 'fd -HI -E .git'

    set -gx FZF_DEFAULT_COMMAND $fd_cmd
    set -gx fzf_ctrl_e_cmd $fd_dirs_cmd
else
    # FZF_DEFAULT_COMMAND not set here; already has sensible
    # default.

    set -gx fzf_ctrl_e_cmd 'find -type d -o -type l'
end

if test -e $fish_local_config
    source $fish_local_config
end
