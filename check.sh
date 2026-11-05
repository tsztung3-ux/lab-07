#!/bin/bash

fail=no

for i in {1,2,3,4}; do
  have_different_in_testcase=no
  result=PASS
  for f1 in Testcase$i/*.1.txt; do
    base=${f1%.1.txt} #after % is excluded
    f2=$base.2.txt

    if ! diff -u "$f1" "$f2" > /dev/null; then
      have_different_in_testcase=yes
      break
    fi # fi is to tell is end of if
  done

  if [ "$have_different_in_testcase" = "no" ]; then
        if [ -d Testcase${i}Diff ]; then # the Testcase1,2,3,4Diff should not exist, but is exist
            result=FAIL
        fi
  else
        if [ ! -d Testcase${i}Diff ]; then # the Testcase1,2,3,4Diff should exist, but is not exist
            result=FAIL
        fi
  fi

  for f1 in Testcase$i/*.1.txt; do
        base=${f1%.1.txt}
        f2=$base.2.txt
        expected=Testcase${i}Diff/$(basename "$base")Diff.txt

        if diff -q "$f1" "$f2" > /dev/null 2>&1; then
            if [ -f "$expected" ]; then # txt should not exit, but the txt exit
                result=FAIL
            fi
        else
            # Pair DIFFERS -> output file must exist with matching content
            if [ ! -f "$expected" ]; then # txt should exit, but the txt not exit
                result=FAIL
            else
                want=$(diff -u "$f1" "$f2" | tail -n +3)
                got=$(tail -n +3 "$expected")
                if [ "$want" != "$got" ]; then
                    echo "$expected has wrong content" >&2
                    result=FAIL
                fi
            fi
        fi
    done

    echo "Testcase${i}: $result"
    if [ "$result" = "FAIL" ]; then
        fail=yes
    fi
done

if [ "$fail" = "yes" ]; then
    exit 1
fi
exit 0
