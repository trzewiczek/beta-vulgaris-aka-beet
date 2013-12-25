#!/bin/bash

for f in test/*; do
  class_name=`echo $f | sed 's/test\/\([a-z]*\)_test.ck/\1/g'`

  echo ""
  echo -e "\e[1mTesting: $class_name\e[21m"
  chuck lib/$class_name $f;
done
