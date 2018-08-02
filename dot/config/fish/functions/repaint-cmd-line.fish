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
      commandline -it -- (string escape $i)
      commandline -it -- ' '
    end
    commandline -f repaint
end
