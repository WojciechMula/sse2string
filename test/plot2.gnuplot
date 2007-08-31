[[ $# -lt 1 ]] && exit
gnuplot << EOF
set terminal png size 500,300
set output "$1b.png"

set title "function $1"
set xlabel "length"
set ylabel "speedup"
set xtics 4096
set key left
set xrange [512:16384]
plot "$1/0-16k"  using 1:(\$2/\$3) title "offset 0" smooth bezier, \
     "$1/7-16k"  using 1:(\$2/\$3) title "offset 7" smooth bezier, \
     "$1/16-16k" using 1:(\$2/\$3) title "offset 16" smooth bezier, \
     "$1/25-16k" using 1:(\$2/\$3) title "offset 25" smooth bezier
EOF
