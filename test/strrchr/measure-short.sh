prog=./strrchr
count=10000
ofs=$1

file="$ofs-256"
for len in `seq 0 4 256`; do
	let n=len+ofs
	let n1=n+8
	let n2=n+16

	$prog 0 $ofs $n $n1 $n2 $count 2 || exit
	
	a=`$prog 0 $ofs $n $n1 $n2 $count 0`
	b=`$prog 0 $ofs $n $n1 $n2 $count 1`
	echo $ofs $len $count $a $b
	echo $len $a $b >> $file
done
