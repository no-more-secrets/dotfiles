function binding-C-o
  test -e Makefile; or return 1
  set -l cores (cores)
  set -l cmd "make -j$cores rn"
  echo $cmd
  eval $cmd
  commandline -f repaint
end
