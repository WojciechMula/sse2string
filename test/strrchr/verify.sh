#!/bin/sh

verbose=0
prog=./strrchr
for ofs in `seq 0 4095`; do
	echo "offset = $ofs/4095"
	for len in `seq 0 256`; do
		$prog $verbose $ofs 16383 $len 256 0 2
		if [[ $? -ne 0 ]]; then
			echo "(a) ofs=$ofs, len=$len"
			exit
		fi
	done
	for len in `seq 256 256 16383`; do
		$prog $verbose $ofs 16383 $len 16383 0 2
		if [[ $? -ne 0 ]]; then
			echo "(b) ofs=$ofs, len=$len"
			exit
		fi
	done
done
