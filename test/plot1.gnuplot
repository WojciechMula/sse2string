[[ $# -lt 1 ]] && exit
gnuplot << EOF
set terminal png size 500,300
set output "$1a.png"

set title "function $1"
set xlabel "length"
set ylabel "speedup"
set xtics 32
set key left
set xrange [0:256]
plot "$1/0-256"  using 1:(\$2/\$3) title "offset 0" smooth bezier, \
     "$1/7-256"  using 1:(\$2/\$3) title "offset 7" smooth bezier, \
     "$1/16-256" using 1:(\$2/\$3) title "offset 16" smooth bezier, \
     "$1/25-256" using 1:(\$2/\$3) title "offset 25" smooth bezier
EOF
