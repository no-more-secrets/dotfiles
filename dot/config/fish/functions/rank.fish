function rank
  grep -v '^$' | sort | uniq -c | sort -nr
end