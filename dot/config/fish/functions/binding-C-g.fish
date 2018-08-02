# Moves up one directory and repaints the cmd line.
function binding-C-g
    cd ..
    commandline -f repaint
end
