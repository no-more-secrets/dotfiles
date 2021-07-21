# Given a file or folder, this will change directory to the
# folder containing it.
function cdf
  if test (count $argv) -gt 1
    echo 'Only one parameter allowed.' >&2
    return 1
  end
  set -l leaf $argv[1]
  set -l dir (dirname $leaf)
  cd $dir
end