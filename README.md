# Matlab_datathief
Small Matlab GUI-tool allowing to pick a series of plot datapoints from an imported image.

Usage:
1) Load a (png or other bitmap) version of a graph, e.g. 
![Example image](https://github.com/willend/Matlab_datathief/raw/master/test.jpg "example image")

2) Define your axis to be linear, lin-log, log-lin or log-log

3) Click two welldefined, diagonal points spanning the graph

4) Input min-max ranges of x and y coordinate

5) Click 'Get data' to start collecting points. Once you have collected what you want, right-click within the graph

6) Save your x-y coordinate set, here is an example (https://raw.githubusercontent.com/willend/Matlab_datathief/master/Ageron.dat):
`1.0304203e+00   4.6599722e+12
 1.2674535e+00   7.1430222e+12
 1.5675302e+00   9.7704454e+12
 2.1384168e+00   8.7186260e+12
 3.0638330e+00   5.8521568e+12
 4.4620721e+00   2.6366456e+12
 6.0871364e+00   1.1545719e+12
 8.3950249e+00   3.6962203e+11
 1.0963984e+01   1.1500802e+11
 1.4319071e+01   4.3678174e+10`
   
   
