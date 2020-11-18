# LVS Manual
The LVS verification is done in Calibre using a SVRF(Standard Verification Rule Format) or TVF(Tcl Verification Format) scripting language in the background. This write-up will throw light on the whole process in a simplified and more understandable manner.
## LVS Data Flow










/CAD/mentor/calibre/2020-2-14-12/aoi_cal_2020.2_14.12/bin/calibre -lvs -hier _xt018_1243_
/CAD/mentor/calibre/2020-2-14-12/aoi_cal_2020.2_14.12/bin/calibre -spice res_test.net _xt018_1243_

/CAD/mentor/calibre/2020-2-14-12/aoi_cal_2020.2_14.12/bin/calibre -spice /home/NIS/projects/XT018-19/A0/work/tt18-pmrudula/LVS/res_test.sp -lvs -hier -nowait /home/NIS/projects/XT018-19/A0/work/tt18-pmrudula/LVS/_xt018_1243_
