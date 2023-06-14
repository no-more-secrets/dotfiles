function fd
  if which fdfind 2>/dev/null 1>&2
    command fdfind $argv
  else
    command fd $argv
  end
end