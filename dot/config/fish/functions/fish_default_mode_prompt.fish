# We override the default version (usually located in
# /usr/share/fish/functions/fish_default_mode_prompt.fish
# so that when in insert mode (which behaves like a normal
# shell prompt) there will be no indicator.  Then, only
# when switching to normal mode, replace mode, or visual
# mode will there be an indicator.

function fish_default_mode_prompt --description "Display the default mode for the prompt"
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        switch $fish_bind_mode
            case default
                set_color --bold --background red white
                echo '[N]'
				set_color normal
				echo -n ' '
            case insert
                set_color --bold --background green white
                #echo '[I]'
				set_color normal
            case replace_one
                set_color --bold --background yellow white
                echo '[R]'
				set_color normal
				echo -n ' '
            case visual
                set_color --bold --background magenta white
                echo '[V]'
				set_color normal
				echo -n ' '
        end
    end
end
