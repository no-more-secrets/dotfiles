function nl
  # - -ba says to number all lines and not just blank lines. It
  #   is a mystery why it does not do this by default.
  command nl -ba $argv
end