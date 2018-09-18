# This function will take a single line from stdin like:
#   a/b/c/d/file.ext:123: ... ...
# And will extract the file name and line number and then construct
# a vim command that opens that file at the line number.
function file-lineno-to-vim
  set -l input $argv[1]
  string length -q $input; or return 1
  set -l line (echo $input | sed -r 's/^[^:]+:([0-9]+):.*/\1/')
  set -l file (echo $input | sed -r 's/^([^:]+).*/\1/')
  repaint-cmd-line "vim +$line $file"
end
