#! /bin/bash

usage=$(cat << EOF
   # This script
   #   
   
   clust.sh [options]

   Options:
      -t <v> : *required* Numberof threads to use.
      -i <v> : *required* Input file.
EOF
);


while getopts f:b:o:t: option
do
    case "${option}"
    in
	t) TC=${OPTARG};;
	i) IN=${OPTARG};;
    esac
done


cat $IN | awk '{print $1}' | uniq > list
for i in `cat list`; do grep -w $i $IN > $i.lists; done
total=$(wc -l list | awk '{print $1}')
n=1
while [ $n -lt $total ]; do
	i=`ps -all | grep 'python' | wc -l`
	if [ $i -lt $TC ] ;
	then
		for i in `cat list`; do python clust.py $i | sort -nk4 >> tmp4 &
		let n=n+1
	else
		let n=n+1
	fi
done
