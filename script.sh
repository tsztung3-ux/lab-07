#!/bin/bash

rm -rf Testcase*Diff

for i in {1,2,3,4}; do
  for f1 in Testcase$i/*.1.txt; do
    base=${f1%.1.txt} #after % is excluded
    f2=$base.2.txt

    if ! diff -u "$f1" "$f2" > /dev/null; then
      mkdir -p Testcase${i}Diff
      diff -u "$f1" "$f2" > Testcase${i}Diff/$(basename "$base")Diff.txt
    fi # fi is to tell is end of if

  done
done
  
