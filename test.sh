#!/bin/sh

for f in test/*; do
  echo $f
  class_name=`echo $f | sed 's/test\/\([a-z]*\)_test.ck/\1/g'`
  chuck lib/$class_name $f;
done
