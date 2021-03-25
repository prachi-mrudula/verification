* SPICE NETLIST
***************************************

.SUBCKT ne5_Auto1
** N=4 EP=0 IP=0 FDC=0
*.SEEDPROM
.ENDS
***************************************
.SUBCKT ne5_mul2 B G D S
** N=4 EP=4 IP=8 FDC=2
M0 S G D B ne5 L=5e-07 W=2e-06 AD=5.4e-13 AS=9.6e-13 PD=2.54e-06 PS=4.96e-06 $X=44390 $Y=-1000 $D=0
M1 D G S B ne5 L=5e-07 W=2e-06 AD=9.6e-13 AS=5.4e-13 PD=4.96e-06 PS=2.54e-06 $X=45430 $Y=-1000 $D=0
.ENDS
***************************************
