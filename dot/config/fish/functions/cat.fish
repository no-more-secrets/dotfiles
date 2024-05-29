function cat
  if which batcat 2>/dev/null 1>&2
    command batcat --paging=never --style=plain $argv
  else
    command cat $argv
  end
end