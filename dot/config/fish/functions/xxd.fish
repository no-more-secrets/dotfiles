function xxd
  set -l width
  if not string length -q $COLUMNS
    set width "-c16"
  else
    set -l arg (math "floor( 10*($COLUMNS-11)/35 )")
    set width "-c$arg"
  end
  command xxd $width $argv
end