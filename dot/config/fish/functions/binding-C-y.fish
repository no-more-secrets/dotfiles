# Runs `make test` with appropriate number of cores.  If
# shift is held then it will be OPT=.
function binding-C-y
  test -e Makefile; or return 1
  set -l cores (cores)
  set -l cmd "make test -j$cores"
  echo $cmd
  eval $cmd
  # This is a hack to allow the error code to propagate out of
  # this function and into the visual indicator in the command
  # prompt.
  set -g status_cache $status
  commandline -f repaint
end
