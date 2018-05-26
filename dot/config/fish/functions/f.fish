# Find  all  files/folders recursively under current folder whose
# basename contains some fragment (case insensitive) of the first
# argument. Note: paths which contain  the search characters only
# in a parent folder will not be included. That  said,  if  there
# are such paths then each of the parent paths will appear in the
# search results once (since `find` will yield directory entries)
# and so their presence will likely not go unnoticed by the  user.
function f
    set -l wildcard 0

    if string match -qr "\*" $argv[1]; or \
       string match -qr "\?" $argv[1]; or \
       string match -qr "\+" $argv[1]; or \
       string match -qr "\." $argv[1]
        # If  input contains wildcard or regex characters then we
        # won't  try  to highlight the matched characters (below)
        # since that requires grepping and  we don't want to grep
        # for regex chars since that  would require escaping them,
        # and that's a pain.
        set wildcard 1
    end

    if test $wildcard -eq 1
        find . -name "*$argv[1]*"
    else
        find . -name "*$argv[1]*" | grep "$argv[1]"
    end
end
