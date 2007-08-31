#!/bin/sh

verbose=0
prog=./strncmp
for k in `seq 0 256`; do
	echo length1=$k, limit=0..256
	for len in `seq 0 256`; do
		$prog $verbose 0 0 $k 16383 $len 0 2
		if [[ $? -ne 0 ]]; then
			echo length1=$k, limit=$len
			exit 1
		fi
	done
done

for k in `seq 256 256 16383`; do
	echo length1=$k, limit=256..16k
	for len in `seq 256 256 16383`; do
		$prog $verbose 0 0 $k 16383 $len 0 2
		if [[ $? -ne 0 ]]; then
			echo length1=$k, limit=$len
			exit 1
		fi
	done
done
