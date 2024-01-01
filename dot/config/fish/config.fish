# ===============================================================
# General
# ===============================================================
set fish_function_path $fish_function_path ~/.config/fish/functions/local

set PATH ~/bin ~/.local/bin ~/.cargo/bin $PATH

export COLUMNS

# ===============================================================
# Prompt
# ===============================================================
set -g fish_prompt_pwd_dir_length 2

function my_vi_bindings
    fish_vi_key_bindings # default version
    # This will allow us to retain the default fish C-F (accept suggestion)
    # feature when VI mode is enabled.
    bind -M insert  \cf forward-char
    bind -M default \cf forward-char
    bind -M visual  \cf forward-char
end

set -g fish_key_bindings my_vi_bindings

# ===============================================================
# Lua
# ===============================================================
set -x LUA_INIT @$HOME/.config/lua/startup.lua

# This needs to come after we set LUA_INIT because that script
# adjusts the LUA_PATH.
if which luarocks >/dev/null 2>&1
    eval (luarocks path --bin)
end

# ===============================================================
# Qt
# ===============================================================
# This scales Qt applications to look good on 4k screens. It
# should however only do the scaling when there is a high pixel
# density.
set -x QT_AUTO_SCREEN_SCALE_FACTOR 1

# ===============================================================
# FZF
# ===============================================================
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

# ===============================================================
# Local Config
# ===============================================================
set -l fish_local_config ~/.config/fish/local-config.fish

if test -e $fish_local_config
    source $fish_local_config
end

# ===============================================================
# vim/nvim
# ===============================================================
if which nvim >/dev/null 2>&1
  set -gx EDITOR nvim
else
  set -gx EDITOR vim
end

# ===============================================================
# Ninja
# ===============================================================
export DSICILIA_NINJA_STATUS_PRINT_MODE=scrolling
export DSICILIA_NINJA_REFORMAT_MODE=pretty

set -x CMAKE_GENERATOR "Ninja"
