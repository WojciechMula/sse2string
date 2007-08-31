prog=./strncmp
count=500
file="$1"
for len in `seq 0 4 256`; do
	$prog 0 0 0 $1 16383 $len $count 2 || exit 1
	
	a=`$prog 0 0 0 $1 16383 $len $count 0`
	b=`$prog 0 0 0 $1 16383 $len $count 1`
		
	echo $len $count $a $b
	echo $len $a $b >> $file
done
