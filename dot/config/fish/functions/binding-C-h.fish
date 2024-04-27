function binding-C-h
  test -e Makefile; or return 1
  commandline "make all"
  commandline -f execute
end
