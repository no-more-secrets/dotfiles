# Runs `make all` without stopping on errors.
function binding-F9
  test -e Makefile; or return 1
  set -l cmd "make all KEEP_GOING=1"
  echo $cmd
  eval $cmd
  # This is a hack to allow the error code to propagate out of
  # this function and into the visual indicator in the command
  # prompt.
  set -g status_cache $status
  commandline -f repaint
end
