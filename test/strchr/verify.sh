#!/bin/sh

verbose=0
prog=./strchr
for ofs in `seq 0 4095`; do
	echo "offset = $ofs/4095"
	for len in `seq 0 256`; do
		$prog $verbose $ofs 16383 $len 256 0 2 || exit
	done
	for len in `seq 256 256 16383`; do
		$prog $verbose $ofs 16383 $len 16383 0 2 || exit
	done
done
