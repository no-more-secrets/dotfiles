# Runs `make run` with appropriate number of cores.  If
# shift is held then it will be OPT=.
function binding-F5
  test -e Makefile; or return 1
  set -l cores (cores)
  set -l cmd "make run -j$cores"
  if test (count argv) -gt 0
    set -l modifier $argv[1]
    if string match -q $modifier "shift"
      set cmd "$cmd OPT="
    end
  end
  echo $cmd
  eval $cmd
  commandline -f repaint
end
