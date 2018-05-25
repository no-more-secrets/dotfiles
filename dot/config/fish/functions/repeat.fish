# Runs the given command (composed of all arguments to the function) N
# times, where N is given as the first parameter to the `repeat` function.
function repeat
    set N   $argv[1]
    set argv $argv[2..-1] # shift
    for i in (seq 1 $N)
        eval $argv
    end
end
