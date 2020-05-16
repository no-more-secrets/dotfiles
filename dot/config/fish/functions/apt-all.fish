function apt-all
  set result (apt list 2>/dev/null | sed -r 's/\/.*//g' | grep -v 'Listing\.\.' | fzf --preview='apt show {} 2>/dev/null')

  if string length -q $result
    if not string length -q (commandline)
        # If the commandline is empty then then put an `sudo apt
        # install` in front of it because we will likely want to
        # install it.
        set result sudo apt install $result
    end
  end

  repaint-cmd-line $result
end