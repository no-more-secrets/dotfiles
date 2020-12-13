# Runs `make update` with appropriate number of cores.  If
# shift is held then it will be OPT=.
function binding-F8
  test -e Makefile; or return 1
  set -l cores (cores)
  set -l cmd "make update -j$cores"
  if test (count $argv) -gt 0
    set -l modifier $argv[1]
    if string match -q $modifier "shift"
      set cmd "$cmd OPT="
    end
  end
  echo $cmd
  eval $cmd
  # This is a hack to allow the error code to propagate out of
  # this function and into the visual indicator in the command
  # prompt.
  set -g status_cache $status
  commandline -f repaint
end
