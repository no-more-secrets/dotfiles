# Gets executed before each (possibly empty) command, i.e., just
# after <enter> is hit at the prompt, but before the command
# runs.  However, it does not get run before key bindings.
function preexec_hook --on-event fish_preexec
  # echo preexec handler: $argv
end

# Gets executed before each (possibly empty) command, i.e., just
# after <enter> is hit at the prompt, but before the command
# runs.  However, it does not get run before key bindings.
function postexec_hook --on-event fish_postexec
  if string length -q $argv
    set --erase status_cache
  end
end

function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    # Unfortunately when running a fish function from a key bind-
    # ing, the error code of the last command in the function
    # cannot be propagated out to be visible in the command
    # prompt. So if a function that is bound to a key wants to
    # propagate its error code then it needs to store it in
    # `status_cache` where it will be picked up here. This
    # status_cache variable will then hold its value until the
    # postexec_hook above runs and resets it, thereby allowing
    # the error code (in status_cache) set by the key binding to
    # linger at the prompt until the next command is run, as usu-
    # ally happens normally with commands.
    if string length -q $status_cache
      set last_status $status_cache
    end

    if not set -q __fish_git_prompt_show_informative_status
        set -g __fish_git_prompt_show_informative_status 1
    end
    if not set -q __fish_git_prompt_hide_untrackedfiles
        set -g __fish_git_prompt_hide_untrackedfiles 1
    end

    if not set -q __fish_git_prompt_color_branch
        set -g __fish_git_prompt_color_branch magenta --bold
    end
    if not set -q __fish_git_prompt_showupstream
        set -g __fish_git_prompt_showupstream "informative"
    end
    if not set -q __fish_git_prompt_char_upstream_ahead
        set -g __fish_git_prompt_char_upstream_ahead "↑"
    end
    if not set -q __fish_git_prompt_char_upstream_behind
        set -g __fish_git_prompt_char_upstream_behind "↓"
    end
    if not set -q __fish_git_prompt_char_upstream_prefix
        set -g __fish_git_prompt_char_upstream_prefix ""
    end

    if not set -q __fish_git_prompt_char_stagedstate
        set -g __fish_git_prompt_char_stagedstate "●"
    end
    if not set -q __fish_git_prompt_char_dirtystate
        set -g __fish_git_prompt_char_dirtystate "✚"
    end
    if not set -q __fish_git_prompt_char_untrackedfiles
        set -g __fish_git_prompt_char_untrackedfiles "…"
    end
    if not set -q __fish_git_prompt_char_conflictedstate
        set -g __fish_git_prompt_char_conflictedstate "✖"
    end
    if not set -q __fish_git_prompt_char_cleanstate
        set -g __fish_git_prompt_char_cleanstate "✔"
    end

    if not set -q __fish_git_prompt_color_dirtystate
        set -g __fish_git_prompt_color_dirtystate blue
    end
    if not set -q __fish_git_prompt_color_stagedstate
        set -g __fish_git_prompt_color_stagedstate yellow
    end
    if not set -q __fish_git_prompt_color_invalidstate
        set -g __fish_git_prompt_color_invalidstate red
    end
    if not set -q __fish_git_prompt_color_untrackedfiles
        set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
    end
    if not set -q __fish_git_prompt_color_cleanstate
        set -g __fish_git_prompt_color_cleanstate green --bold
    end

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    set -l color_cwd
    set -l prefix
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
            set color_cwd $fish_color_cwd
            set suffix ':'
    end

    # PWD
    set_color normal

    if not test $last_status -eq 0
        printf '('
        set_color F00 #$fish_color_error
        echo -n $last_status
        set_color normal
        printf ') '
    end

    set_color normal

    if string length -q $SSH_CLIENT; and not string match -qr google (hostname)
        printf "["
        set_color yellow
        printf "%s" (hostname)
        set_color normal
        printf "] "
    end

    set -l vcs (string trim (__fish_vcs_prompt))
    if string length -q $vcs
        printf '%s ' $vcs
    end

    set_color BBF #$color_cwd
    if functions -q local_pwd_fmt
        echo -n (local_pwd_fmt)
    else
        echo -n (prompt_pwd)
    end

    set_color normal
    echo -n "$suffix "

end
