# Display a fortune if the program is installed.
function fish_greeting
	# test -x /usr/games/fortune; and /usr/games/fortune
    # or echo "run sudo apt install fortunes"
    echo -n Welcome to the Fish.
    sleep 0.2
    echo -en "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
end
