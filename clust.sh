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


while getopts i:t: option
do
    case "${option}"
    in
	t) TC=${OPTARG};;
	i) INP=${OPTARG};;
    esac
done


cat $INP | awk '{print $1}' | uniq > list
for e in `cat list`; do grep -w $e $INP > $e.lists; done
total=$(wc -l list | awk '{print $1}')
n=1
while [ $n -lt $total ]; 
	do r=`ps -all | grep 'python' | wc -l`
		if [ $r -lt $TC ]
		then
			for g in `cat list`; do python clust.py $g | sort -nk4 >> tmp4 &
			let n=n+1
		else
			echo "No core"
			sleep 15s
		fi
	done
done
