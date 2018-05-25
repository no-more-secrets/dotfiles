# Print the sum, count, min, max, average, and std.dev of list of numbers
# from stdin.
function avg
    awk '
    BEGIN {
        total    = 0
        total_sq = 0
        min_set  = 0
        max_set  = 0
        count    = 0
    }

    {
        val = $1
        /* Trick for deciding whether val is a number. */
        if( val == val+0 ) {
            print val
            total    += val
            total_sq += (val*val)
            count    += 1
            if( !min_set ) {
                min = val
                min_set = 1
            }
            if( !max_set ) {
                max = val
                max_set = 1
            }
            if( $1 < min ) {
                min = val
            }
            if( $1 > max ) {
                max = val
            }
        } else {
            print "  *** ignoring non-numerical value \"" val "\"" >"/dev/stderr"
        }
    }

    END {
        print "------------------------------------------------"
        print "total:  ", total
        print "min:    ", min
        print "max:    ", max
        print "count:  ", count
        if( count > 0 ) {
            avg     = total/count
            std_dev = sqrt( total_sq/count - (avg*avg) )
            print "avg/dev:", avg, "+-", std_dev
        }
        print "------------------------------------------------"
    }'
end
