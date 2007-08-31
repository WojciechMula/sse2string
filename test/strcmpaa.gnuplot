[[ $# -lt 1 ]] && exit
gnuplot << EOF
set terminal png size 500,300
set output "strcmpaa.png"

set title "function $1"
set xlabel "length"
set ylabel "speedup"
set xtics 32
set key left
set xrange [0:256]
plot \
   "$1/0-0-256"   using 1:(\$2/\$3) title "offsets 0, 0"   smooth bezier, \
   "$1/0-16-256"  using 1:(\$2/\$3) title "offsets 0, 16"  smooth bezier, \
   "$1/16-0-256"  using 1:(\$2/\$3) title "offsets 16, 0"  smooth bezier
EOF
