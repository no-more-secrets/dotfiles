# Clips output to the number of columns on the display
function clip
    sed -ru 's/(.{0,'$COLUMNS'}).*/\1/g'
end
