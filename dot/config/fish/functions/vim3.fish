function vim3
    if functions -q local-vim3
        local-vim3 $argv
        set -l ret $status
        if test $ret -ne 253
          return $ret
        end
        # local-vim3 did not handle, so proceed.
    end

    if test (count $argv) -ne 1
        echo "Must give exactly one argument to vim3." >&2
        return 1
    end

    set -l bn (basename $argv[1])
    set -l stem (echo $bn | rev | cut -f 2- -d '.' | rev)

    set -l dn (dirname $argv[1])/
    set -l inner (echo $dn | sed -r 's/^[^/]+\///')

    vim src/$inner$stem.hpp src/$inner$stem.cpp test/$inner$stem.cpp -O
end
