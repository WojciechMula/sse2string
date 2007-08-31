prog=./strcmp
count=300
ofs1=$1
ofs2=$2

file="$ofs1-$ofs2-16k"
for len in `seq 512 512 16383`; do
	let n=len+ofs1
		
	$prog 0 $ofs1 $ofs2 $n 16383 $count 2 || exit
		
	a=`$prog 0 $ofs1 $ofs2 $n 16383 $count 0`
	b=`$prog 0 $ofs1 $ofs2 $n 16383 $count 1`
	echo $ofs1 $ofs2 $len $count $a $b
	echo $len $a $b >> $file
done
