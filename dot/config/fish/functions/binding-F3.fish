function binding-F3
    set -l result ""
    set -l handled 1 # initially not handled

    if [ ! $handled -eq 0 ]; and functions -q local-binding-F3
        set result (local-binding-F3); set handled $status
    end

    if [ ! $handled -eq 0 ]
        # Insert non-local handler here...
    end

    if not string length -q $result
      return
    end

    repaint-cmd-line $result
end
