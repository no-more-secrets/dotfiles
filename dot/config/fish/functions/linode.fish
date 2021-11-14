# ssh into the linode server and auto-attach to tmux. Note that
# when subsequently detaching from the session, it will also au-
# tomatically log out as well.
function linode
  ssh linode -t tmux attach
end