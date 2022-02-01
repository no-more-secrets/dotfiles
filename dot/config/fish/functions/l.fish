function l
  if which exa 2>/dev/null 1>&2
    exa --group-directories-first -l $argv
  else
    ls -l $argv
  end
end
