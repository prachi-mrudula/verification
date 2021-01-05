* SPICE NETLIST
***************************************

.SUBCKT inv_test In Gnd VDD out
** N=4 EP=4 IP=0 FDC=2
M0 out In VDD VDD pe L=1.8e-07 W=2e-06 AD=9.6e-13 AS=9.6e-13 PD=4.96e-06 PS=4.96e-06 $X=3110 $Y=3370 $D=0
M1 out In Gnd Gnd ne L=1.8e-07 W=2e-06 AD=9.6e-13 AS=9.6e-13 PD=4.96e-06 PS=4.96e-06 $X=3110 $Y=-1650 $D=1
.ENDS
***************************************
