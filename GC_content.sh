#! /bin/bash

usage=$(cat << EOF
   # This script
   #   
   
   clust.sh [options]

   Options:
      -i <v> : *required* Input file.
EOF
);


while getopts i: option
do
    case "${option}"
    in
    i) IN=${OPTARG};;
    esac
done

awk ' \
    BEGIN { \
        FS=""; \
        cg=0; \
        t=0; \
    } \
    { \
        if ($1 != ">") { \
            for (i = 1; i <= NF; i++) { \
                t++; \
                if ($i ~ /[CGcg]/) { \
                    cg++;
                } \
            } \
        } \
    } \
    END { \
        print (cg/t); \
    }' $IN