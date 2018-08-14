function binding-C-k
    set -l result ""
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and functions -q local-binding-C-k
        set result (local-binding-C-k); set handled $status
    end

    repaint-cmd-line $result
end
