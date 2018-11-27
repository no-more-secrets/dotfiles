function less
  # Let escape sequences pass through in raw form.  This allows less
  # to display both colors and non-ascii chars.
  command less -r $argv
end
