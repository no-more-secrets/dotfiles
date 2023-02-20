function binding-C-k
    set -l result ""
    set -l handled 1 # initially not handled

    if test -e Makefile
      ~/dev/utilities/cmake/build-options.sh
      # This is a hack to allow the error code to propagate out
      # of this function and into the visual indicator in the
      # command prompt.
      set -g status_cache $status
      commandline -f repaint
      return
    end

    if [ ! $handled -eq 0 ]; and functions -q local-binding-C-k
        set result (local-binding-C-k); set handled $status
    end

    repaint-cmd-line $result
end
