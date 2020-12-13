# Runs `make` with single core and keep only first page of
# results. If shift is held then it will be OPT=.
function binding-F7
  test -e Makefile; or return 1
  set -l num_lines 0
  if not string length -q $LINES
    set num_lines 5
  else
    set num_lines (math $LINES - 2)
  end
  set -l cmd "make -j1 2>&1 | head -n$num_lines"
  if test (count $argv) -gt 0
    set -l modifier $argv[1]
    if string match -q $modifier "shift"
      set cmd "make -j1 2>&1 | clip | head -n$num_lines"
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
