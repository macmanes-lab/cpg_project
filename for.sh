#! /bin/bash

usage=$(cat << EOF
   # This script
   #   
   
   clust.sh [options]

   Options:
      -o <v> : *required* output file.
      -i <v> : *required* Input file.
EOF
);


while getopts i:o: option
do
    case "${option}"
    in
	o) OUT=${OPTARG};;
	i) IN=${OPTARG};;
    esac
done


nline=`expr $(wc -l $IN | awk '{print $1}') - 1`
for i in `seq 1 $nline`; do \
	echo `expr $(awk 'NR == '$i'+1 {print $2}' $IN) - $(awk 'NR == '$i' {print $2}' $IN)` >> $OUT; done
