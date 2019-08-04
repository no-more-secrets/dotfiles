# Get diff of file (first argument) between HEAD and the commit
# just before it was last modified.  Taken from:
#
#   https://stackoverflow.com/questions/10176601/git-diff-file-against-its-last-change
function git-last-diff
  git log -p --follow -1 $argv
end
