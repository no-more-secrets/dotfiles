# Re-routes vim to neovim if it is available.
function vim
  if which nvim &>/dev/null
    nvim $argv
  else
    vim $argv
  end
end