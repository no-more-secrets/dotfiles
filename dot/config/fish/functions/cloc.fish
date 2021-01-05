function cloc
  if test (count $argv) -ge 1
    command cloc $argv
  else
    command cloc .
  end
end