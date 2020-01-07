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

    vim src/$stem.hpp src/$stem.cpp test/$stem.cpp -O
end
