function cat
  if which bat 2>/dev/null 1>&2
    command bat --paging=never --style=plain $argv
  else
    command cat $argv
  end
end