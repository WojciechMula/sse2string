[[ $# -lt 1 ]] && exit
gnuplot << EOF
set terminal png size 500,300
set output "strcmpua.png"

set title "function $1"
set xlabel "length"
set ylabel "speedup"
set xtics 32
set key left
set xrange [0:256]
plot \
   "$1/0-7-256"   using 1:(\$2/\$3) title "offsets 0, 7"   smooth bezier, \
   "$1/0-25-256"  using 1:(\$2/\$3) title "offsets 0, 25"  smooth bezier, \
   "$1/7-0-256"   using 1:(\$2/\$3) title "offsets 7, 0"   smooth bezier, \
   "$1/7-7-256"   using 1:(\$2/\$3) title "offsets 7, 7"   smooth bezier, \
   "$1/7-16-256"  using 1:(\$2/\$3) title "offsets 7, 16"  smooth bezier, \
   "$1/7-25-256"  using 1:(\$2/\$3) title "offsets 7, 25"  smooth bezier, \
   "$1/16-7-256"  using 1:(\$2/\$3) title "offsets 16, 7"  smooth bezier, \
   "$1/16-16-256" using 1:(\$2/\$3) title "offsets 16, 16" smooth bezier, \
   "$1/16-25-256" using 1:(\$2/\$3) title "offsets 16, 25" smooth bezier, \
   "$1/25-0-256"  using 1:(\$2/\$3) title "offsets 25, 0"  smooth bezier, \
   "$1/25-7-256"  using 1:(\$2/\$3) title "offsets 25, 7"  smooth bezier, \
   "$1/25-16-256" using 1:(\$2/\$3) title "offsets 25, 16" smooth bezier, \
   "$1/25-25-256" using 1:(\$2/\$3) title "offsets 25, 25" smooth bezier
EOF