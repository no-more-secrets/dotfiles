function cores
  if string match -q (uname) Linux
    nproc --all
  else
    sysctl -n hw.ncpu
  end
end
