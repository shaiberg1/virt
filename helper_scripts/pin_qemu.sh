#!/bin/bash

PID_LIST=

while [ $((`echo "$PID_LIST" | wc -l`)) -ne $(($1)) ]
do
    sleep 1
    PID_LIST=`sudo ps -axH -o tid,ucmd | grep KVM | grep CPU`
done

CUR_CPU=0

while IFS= read -r line; do
    LINE=`echo ${line##*( )} | cut -f 1 -d " "`
	sudo taskset -cp $CUR_CPU $LINE > /dev/null
	CUR_CPU=$((CUR_CPU+1))

done <<< "$PID_LIST"

echo "PINNED CPUS"
