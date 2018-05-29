# Runs the given command (composed of all arguments to the function) N
# times, where N is given as the first parameter to the `repeat` function.
#
# WARNING: does not work with arguments that have spaces in them!
#
# This version however runs them in parallel. Nevertheless, the GNU
# parallel program will ensure that the order of output will correspond to
# the order of input (i.e., no write conflicts in the output) since we use
# the --keep-order flag.
function repeat_par
    set N $argv[1]
    set argv $argv[2..-1] # shift
    seq 1 $N | parallel --keep-order /usr/bin/fish -c "\"$argv\""
end
