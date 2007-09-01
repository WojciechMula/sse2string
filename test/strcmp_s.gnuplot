[[ $# -lt 2 ]] && exit
funname=$1
pngname=$2
shift 2

[[ $# -lt 1 ]] && exit

cat > tmp << EOF
set terminal png size 500,300
set output "$pngname"

set title "function $funname"
set xlabel "length"
set ylabel "speedup"
set xtics 32
set key left
set xrange [0:256]
plot \\
EOF

while [[ $# -gt 1 ]]; do
	a=$1
	b=$2
	shift 2

	echo -n "\"$funname/$a-$b-256\" using 1:(\$2/\$3) title \"offsets $a, $b\" smooth bezier" >> tmp
	[[ $# -gt 1 ]] && echo -n ", " >> tmp
done

gnuplot tmp
#rm -f tmp
