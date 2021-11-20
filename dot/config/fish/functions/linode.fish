# ssh into the linode server and auto-attach to tmux. Note that
# when subsequently detaching from the session, it will also au-
# tomatically log out as well.
function linode
  # The -t option is a special ssh option that appears to be re-
  # quired for this exact purpose.  From the ssh man page:
  #
  #   -t Force pseudo-terminal allocation. This can be used to
  #      execute arbitrary screen-based programs on a remote ma-
  #      chine, which can be very useful, e.g. when implementing
  #      menu services. Multiple -t options force tty allocation,
  #      even if ssh has no local tty.
  #
  ssh linode -t tmux attach
end