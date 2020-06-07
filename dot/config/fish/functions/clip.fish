# Clips output to the number of columns on the display
function clip
  if test -x ~/dev/utilities/clip/.builds/current/exe
    ~/dev/utilities/clip/.builds/current/exe $COLUMNS
  else
    sed -ru 's/(.{0,'$COLUMNS'}).*/\1/g'
  end
end
