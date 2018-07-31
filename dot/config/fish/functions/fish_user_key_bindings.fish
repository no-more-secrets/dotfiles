function fish_user_key_bindings
  fzf_key_bindings

  # Bind <C-E> to cd widget.
  bind \ce fzf-cd-widget

  if bind -M insert > /dev/null 2>&1
    bind -M insert \ce fzf-cd-widget
  end
end
