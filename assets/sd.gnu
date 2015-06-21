
reset

# wxt
# set terminal wxt size 350,262 enhanced font 'Verdana,10' persist
# png
#set terminal pngcairo size 350,262 enhanced font 'Verdana,10'
#set output 'plotting_data3.png'
# svg
# set terminal svg size 1000,618 fname 'Verdana, Helvetica, Arial, sans-serif' \
# fsize '10'
set terminal png size 650,402 enhanced font "Helvetica,12"
set output "standard-dev.png"
set xrange [0:6]
set yrange [0:6]
set grid
unset key

set style line 1 lc rgb 'black' pt 7 ps 1.2 # circle
set style line 2 lt 1 lc rgb 'red' pt 7   # circle
set style line 3 lc rgb 'blue' pt 7   # circle


set style arrow 2 head filled ls 2
set arrow 1 from 1,5 to 1,3.4 as 2
set arrow 2 from 2,3 to 2,3.4 as 2
set arrow 3 from 3,1 to 3,3.4 as 2
set arrow 4 from 4,3 to 4,3.4 as 2
set arrow 5 from 5,5 to 5,3.4 as 2

set style arrow 3 nohead filled ls 3
plot 3.4 ls 3, \
     'pts.data' u 1:2 with points ls 1

