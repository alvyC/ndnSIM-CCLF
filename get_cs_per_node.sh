#!/bin/bash

file_name=$1
no_of_nodes=$2

start_line_number=$(grep -Irn "Interest for 0" $file_name | cut -d: -f1)

#touch ${file_name}_processed

for n in  `seq 0 $no_of_nodes`
do
  echo "Score Node#$n"
  tail -n +$start_line_number $file_name | awk -v a="$n" '{if($2 == a) print $N}' | grep "/test/prefix/a. Score is" | awk '{print $1, $NF}' # for longest matched prefix 
  #tail -n +$start_line_number $file_name | awk -v a="$n" '{if($2 == a) print $N}' | grep "Increasing interest and data count for /test/prefix" | awk '{print $1, $NF}' | uniq -f 1
done

rm -f $file_name.tmp

# OnTime
# DATA for 0
#Hop count:
