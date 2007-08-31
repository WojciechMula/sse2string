[[ $# -lt 1 ]] && exit
gnuplot << EOF
set terminal png size 500,300
set output "strncmpb.png"

set title "function unsafe $1"
set xlabel "length"
set ylabel "speedup"
set xtics 4096
set nokey
set xrange [512:16384]
plot "$1/16383"  using 1:(\$2/\$3) smooth bezier
EOF
