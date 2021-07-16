function cal
  # ncal is needed for highlighting of the day (cal does not seem
  # to do that). -b is needed for ncal to output in the cal
  # format (i.e., days as columns).
  ncal -b (date "+%Y")
end