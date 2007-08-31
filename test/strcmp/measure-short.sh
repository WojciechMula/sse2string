prog=./strcmp
count=500
ofs1=$1
ofs2=$2

file="$ofs1-$ofs2-256"
for len in `seq 0 4 256`; do
	let n=len+ofs1
		
	$prog 0 $ofs1 $ofs2 $n 16383 $count 2 || exit
		
	a=`$prog 0 $ofs1 $ofs2 $n 16383 $count 0`
	b=`$prog 0 $ofs1 $ofs2 $n 16383 $count 1`
	echo $ofs1 $ofs2 $len $count $a $b
	echo $len $a $b >> $file
done
