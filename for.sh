#! /bin/bash

usage=$(cat << EOF
   # This script
   #   
   
   clust.sh [options]

   Options:
      -o <v> : *required* output file.
      -i <v> : *required* Input file.
      -n <v> : *required* nline.
EOF
);


while getopts i:o: option
do
    case "${option}"
    in
	o) OUT=${OPTARG};;
	i) IN=${OPTARG};;
	n) NLINE=${OPTARG};;
    esac
done

for i in `seq 1 $NLINE`; do \
	echo `expr $(awk 'NR == '$i'+1 {print $2}' $IN) - $(awk 'NR == '$i' {print $2}' $IN)` | tee -a $OUT; done