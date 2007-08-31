[[ $# -lt 1 ]] && exit
gnuplot << EOF
set terminal png size 500,300
set output "strcmpab.png"

set title "function $1"
set xlabel "length"
set ylabel "speedup"
set xtics 2048
set key left
set xrange [512:16384]
plot \
   "$1/0-0-16k"   using 1:(\$2/\$3) title "offsets 0, 0"   smooth bezier, \
   "$1/0-16-16k"  using 1:(\$2/\$3) title "offsets 0, 16"  smooth bezier, \
   "$1/16-0-16k"  using 1:(\$2/\$3) title "offsets 16, 0"  smooth bezier
EOF
