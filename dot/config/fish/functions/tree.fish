function tree
  if which exa ^/dev/null 1>&2
    exa -T $argv
  else
    command tree $argv
  end
end
