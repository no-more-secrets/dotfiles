# Repaints the current commandline with argv.
# This logic taken from fzf_key_bindings.fish.
function repaint-cmd-line
    if not string length -q $argv
      commandline -f repaint
      return
    else
      # Remove last token from commandline.
      commandline -t ""
    end
    for i in $argv
      # Just in case all the args will smushed
      # into one string, which can happen.
      for j in (string split ' ' $i)
          commandline -it -- (string escape $j)
          commandline -it -- ' '
      end
    end
    commandline -f repaint
end
