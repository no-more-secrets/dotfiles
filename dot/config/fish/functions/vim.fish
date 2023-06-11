# Re-routes vim to neovim if it is available.
function vim
  if which nvim &>/dev/null
    command nvim $argv
  else
    command vim $argv
  end
end