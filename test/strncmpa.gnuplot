[[ $# -lt 1 ]] && exit
gnuplot << EOF
set terminal png size 500,300
set output "strncmpa.png"

set title "function unsafe $1"
set xlabel "length"
set ylabel "speedup"
set xtics 32
set nokey
set xrange [0:256]
plot "$1/256"  using 1:(\$2/\$3) smooth bezier
EOF
