#!/bin/sh

verbose=0
prog=./strcmp
for o1 in `seq 0 32`; do
	echo "offset1 = $o1/32, offset2 = 0..32"
	for o2 in `seq 0 32`; do
		for len in `seq 0 256`; do
			$prog $verbose $o1 $o2 $len 16383 0 2 || exit 1
		done
		for len in `seq 256 256 16383`; do
			$prog $verbose $o1 $o2 16383 $len 0 2 || exit 1
		done
	done
done
