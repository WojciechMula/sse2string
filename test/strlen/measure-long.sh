prog=./strlen
count=500
ofs=$1

file="$ofs-16k"
for len in `seq 512 512 16383`; do
	let n=len+ofs
		
	$prog 0 $ofs $n $count 2 || exit
		
	a=`$prog 0 $ofs $n $count 0`
	b=`$prog 0 $ofs $n $count 1`
	echo $ofs $len $count $a $b
	echo $len $a $b >> $file
done
