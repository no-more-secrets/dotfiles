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

set -l fish_local_config ~/.config/fish/local-config.fish

set PATH ~/bin ~/.local/bin $PATH

set -g fish_prompt_pwd_dir_length 2

set -gx EDITOR $HOME/dev/tools/vim-current/bin/vim

set -x COLUMNS

# This scales Qt applications to look good on 4k screens. It
# should however only do the scaling when there is a high pixel
# density.
set -x QT_AUTO_SCREEN_SCALE_FACTOR 1

set -gx FZF_DEFAULT_OPTS "
    --height 40%
    --reverse
    --multi
    --ansi
    --select-1
    --preview-window=right:45%
    --color fg:-1,hl:230,fg+:3,hl+:229
    --color info:150,prompt:110,spinner:150,pointer:167,marker:174
"

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

# Someone is setting this above, don't know who, so we need to
# set it down here.
set -x EDITOR $HOME/dev/tools/vim-current/bin/vim
