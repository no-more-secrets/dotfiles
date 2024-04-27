# Runs `make all` without stopping on errors.
function binding-F9
  test -e Makefile; or return 1
  set -l cmd "make all KEEP_GOING=1"
  # Put the command on the command line and then execute it in a
  # way that then puts it in the fish history.
  commandline $cmd
  commandline -f execute
end
