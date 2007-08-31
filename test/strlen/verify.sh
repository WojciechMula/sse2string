#!/bin/sh

verbose=0
prog=./strlen
for ofs in `seq 0 4095`; do
	echo "offset = $ofs/4095"
	for len in `seq 0 256`; do
		$prog $verbose $ofs $len 0 2 || exit 1
	done
	for len in `seq 256 256 16383`; do
		$prog $verbose $ofs $len 0 2 || exit 1
	done
done
