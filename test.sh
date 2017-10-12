#!/bin/bash


COUNT=10
STR=101
END=$(($STR+$COUNT-1))

for i in $(seq $STR $END)
do
  echo 'i:'$i;
done
