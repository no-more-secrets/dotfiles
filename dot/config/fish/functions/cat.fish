function cat
  if which bat 2>/dev/null 1>&2
    command bat --style=plain $argv
  else
    cat $argv
  end
end