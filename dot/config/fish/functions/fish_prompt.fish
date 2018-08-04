function fish_prompt --description 'Write out the prompt'
	# Save our status
    set -l last_status $status

    # Hack; fish_config only copies the fish_prompt function (see #736)
    if not set -q -g __fish_classic_git_functions_defined
        set -g __fish_classic_git_functions_defined

        function __fish_repaint_user --on-variable fish_color_user --description "Event handler, repaint when fish_color_user changes"
            if status --is-interactive
                commandline -f repaint ^/dev/null
            end
        end

        function __fish_repaint_host --on-variable fish_color_host --description "Event handler, repaint when fish_color_host changes"
            if status --is-interactive
                commandline -f repaint ^/dev/null
            end
        end

        function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
            if status --is-interactive
                commandline -f repaint ^/dev/null
            end
        end

        function __fish_repaint_bind_mode --on-variable fish_key_bindings --description "Event handler; repaint when fish_key_bindings changes"
            if status --is-interactive
                commandline -f repaint ^/dev/null
            end
        end

        # initialize our new variables
        if not set -q __fish_classic_git_prompt_initialized
            set -qU fish_color_user
            or set -U fish_color_user -o green
            set -qU fish_color_host
            or set -U fish_color_host -o cyan
            set -qU fish_color_status
            or set -U fish_color_status red
            set -U __fish_classic_git_prompt_initialized
        end
    end

    set -l last_status_string ""
    if [ $last_status -ne 0 ]
        printf "(%s%d%s) " (set_color red --bold) $last_status (set_color normal)
    end

    set -l color_cwd
    set -l suffix
    switch $USER
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd BBF #$fish_color_cwd
            set suffix ':'
    end

    if test -z $prompt_hostname
        set prompt_hostname (hostname)
    end

    if functions -q local_pwd_fmt
        set local_pwd (local_pwd_fmt $color_cwd)
    else
        set local_pwd (prompt_pwd)
    end
    set -l peach f4e49d
    #echo -n -s (set_color ffdddd)"$USER" (set_color white)@ (set_color ccffcc) $prompt_hostname(set_color normal) (__terlar_git_prompt) ' ' (set_color $color_cwd) $local_pwd (set_color normal) "$suffix "
    echo -n -s (set_color ccffff) $prompt_hostname(set_color normal) (__terlar_git_prompt) ' ' (set_color $color_cwd) $local_pwd (set_color normal) "$suffix "
    #__terlar_git_prompt
    #__fish_vcs_prompt

end
