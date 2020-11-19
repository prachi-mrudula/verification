# LVS Manual
The LVS verification is done in Calibre using a SVRF(Standard Verification Rule Format) or TVF(Tcl Verification Format) scripting language in the background. This write-up will throw light on the whole process in a simplified and more understandable manner.
## LVS Data Flow
![LVS_FLOW](https://github.com/prachi-mrudula/verification/blob/main/LVS/lvs_flow.png)
*Source: Calibre Verification User Manual*
## Input Files
1. Rule file: A SVRF or TVF code which contains all the information of the layers and the devices.
2. Layout Database: The extracted netlist from layout and its related information is contained here.
3. Source Database: Contains the netlist of schematic(source) in SPICE and its related informations.
## Rule file
This is further classified into 2 types: 
1. Specification statements: Used to define layout and source databases, paths to output files and set the working environment for the process. 
2. Layer operations: Provides the layer data by performing operations on them thus deriving the layer informations.
## Command Line LVS( nmLVS and nmLVS-H)
* General format for running LVS:
``` bash
calibre [ -lvs [ [ { -tl || -ts } cnet_file_name ][ -nonames ] [ -cell ][ -dblayers "name1,..." ][ -bpf [ no-extents ] ] [ -nl ] [ -cb ]] || [ -hier [ -automatch || -genhcells[=qs_tcl_file_name] ] || -flatten][ -ixf ] [ -nxf ]] 
```
- Firstly, layout netlist has to be extracted and stored in a file for LVS comparison between netlists.
  - General format:
``` bash
calibre -spice <spice_file> <rulefile>
```
* `-spice` command extracts the netlist from the layout.
* `<spice_file>` is the name of the file with extension as .net or .sp where the generated netlist from the layout will be stored.
* `<rulefile>` is the ruledeck file name that is to be used.(Layout system is GDSII)
* As an example, let the LVS is being run a file named 'res_test' and `_xt018_1243_` is the rule file. This is run in the same path where the rule file is present.
``` bash
/CAD/mentor/calibre/2020-2-14-12/aoi_cal_2020.2_14.12/bin/calibre -spice res_test.net _xt018_1243_
```
* The netlist for the example 'res_test' which consists of a polyresistor(rnp1) as generated in the res_test.net:
``` bash
.SUBCKT res_test A B
** N=4 EP=2 IP=0 FDC=1
R0 A B L=1e-05 W=2e-06 $[rnp1] $X=-1025 $Y=-1525 $D=122
.ENDS
```
* Then, the netlists of both the source(schematic) and the layout are compared.
* General format:
``` bash
calibre -lvs -hier <rulefile>
```
* `-lvs` performs the lvs comparison and can be used with variable options.
* `-hier` is used with -lvs option to compare the netlists hierarchically.
* `<rulefile>` is the ruledeck file name that is to be used.(Layout system is GDSII)
* As an example, the LVS is being run a file named 'res_test' and `_xt018_1243_` is the rule file. 
``` bash
/CAD/mentor/calibre/2020-2-14-12/aoi_cal_2020.2_14.12/bin/calibre -lvs -hier _xt018_1243_
```
* Both the netlist extraction from layout and the netlist-netlist comparison can also be performed in a single step:
``` bash
/CAD/mentor/calibre/2020-2-14-12/aoi_cal_2020.2_14.12/bin/calibre -spice /home/NIS/projects/XT018-19/A0/work/tt18-pmrudula/LVS/res_test.sp -lvs -hier -nowait /home/NIS/projects/XT018-19/A0/work/tt18-pmrudula/LVS/_xt018_1243_
```
* `-nowait` 
## Output Files
* The output files that are generated after running the LVS are:
1. `netlistLAYOUT` : This filename is specified in the rulefile as " LVS WRITE LAYOUT NETLIST : netlistLAYOUT ". It contains the netlist of the layout and is mainly used for debugging purposes.
2. `netlistSOURCE` : This filename is specified in the rulefile as " LVS WRITE SOURCE NETLIST : netlistSOURCE ". It contains the netlist of the schematic and is mainly used for debugging purposes.
3. `lvs.summary` : It is the LVS Summary report which contains extraction and LVS comparison information like:
   * Start time and finish time of extraction and comparison.
   * Extraction and comparison report file names : `cellname.lvs.report.ext` and `cellname.lvs.report` respectively
   * Extracted SPICE Netlist path and file name : `cellname.sp`
   * LVS comparison status (correct/incorrect)  
4. `cellname.lvs.report.ext` : It is the circuit extraction report file which contains the following info:
   * Report file name : cellname.lvs.report
   * Layout name: cellname.calibre.db (layout database)
   * Creation time            
   * Current directory         
   * User name              
   * Calibre version
5. `cellname.lvs.report` : It is the LVS report file which in addition to the info mentioned in cellname.lvs.report.ext has the following data:
   * Source name: cellname.src.net
   * Rule file and rule file title
   * Overall comparison results
   * Cell summary
   * LVS parameters
   * Cell comparison results
   * Information and warnings
   * Summary
   



