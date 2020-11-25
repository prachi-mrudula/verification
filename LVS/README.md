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
* This is further classified into 2 types: 
  1. Specification statements: Used to define layout and source databases, paths to output files and set the working environment for the process. 
  2. Layer operations: Provides the layer data by performing operations on them thus deriving the layer informations.
* A simple diagram to depict the structure of the rule files in Calibre is given below:
![rule_file_struc](https://github.com/prachi-mrudula/verification/blob/main/LVS/rule_file_struc.png)
  1. `_xt018_1243_` : A template has been provided [rulefile1](https://github.com/prachi-mrudula/verification/blob/main/LVS/_xt018_1243_temp)
  2. `xt018_1243` : A template has been provided [rulefile2](https://github.com/prachi-mrudula/verification/blob/main/LVS/xt018_1243_temp)
  3. `xt018.rul` : This is the main rule file containing all the layer and device definitions, layer operations, rule checks, connectivity information and setup defaults. Information on the commands used are provided in the next section.
### Commands used in rule file:
* LAYER: Defines the name of an original layer or a layer set that Calibre uses. Format:- `LAYER name original_layer` where,
   * `name`: A required name for an original layer or layer set. 
   * `original_layer`: The layer number of an original layer. 
* LAYER MAP: Enables Calibre to map layer numbers, DATATYPE attributes, and TEXTTYPE attributes in GDS and OASIS databases to layer numbers that Calibre uses in the rule file. Format: `LAYER MAP source_layer DATATYPE/TEXTTYPE source_type target_layer`
   * `source_layer` : The layer number in layout database for mapping.
   * `DATATYPE`: This maps drawn geometric layers.
   * `TEXTTYPE`: This maps text layer objects.
   * `source_type`: It specifies a particular datatype or texttype in the layout database.
   * `target_layer`: It specifies the layer number to be used by Calibre. 
* TEXT LAYER : Specifies the layers in the layout database from which text is read for connectivity extraction. The connectivity extractor uses only those text objects having layers that appear in Text Layer specification statements. Thus, if there are no Text Layer specification statements in the rule file, then no layout database text objects are used by the connectivity extractor, and there will be no net names assigned from such objects. 
* PORT LAYER TEXT : Causes Port Layer Text objects on the specified layer(s) to be read and treated as top-level ports in geometric databases. Its object names in the top-level cell are output by the SPICE netlister(calibre -spice) as top-level subcircuit pin names. Port text objects can be attached to port shapes using explicit attachment (Attach), implicit attachment (both port text and port shapes are on the same Connect layer), or free attachment(Label Order).
* ATTACH : attaches connectivity information from a layer1 object to a layer2 object. It is used for naming nets and ports. It transfers connectivity information from a specified original database source layer (a text layer) to a specified original or derived target layer that appears in a Connect or Sconnect operation. Most often, Attach is used when there is a single text layer (or a few text layers) that is used for label assignment throughout the design. Format:- `ATTACH A B`, where `A` is a Text Layer argument (or A is a layer set that contains the label layer), then the connectivity extractor looks for a polygon on layer `B` that intersects the label location. If found, the label name is assigned to the net that contains that polygon.
* 
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
* `-nowait` :- specifies that waiting time /queuing time to obtain a license is 0.
## Output Files
* The output files that are generated after running the LVS are:
1. `netlistLAYOUT` : This filename is specified in the rulefile as " LVS WRITE LAYOUT NETLIST : netlistLAYOUT ". It contains the netlist of the layout and is mainly used for debugging purposes.
2. `netlistSOURCE` : This filename is specified in the rulefile as " LVS WRITE SOURCE NETLIST : netlistSOURCE ". It contains the netlist of the schematic and is mainly used for debugging purposes.  
3. `cellname.lvs.report.ext` : It is the circuit extraction report file which contains the following info:
   * Report file name : cellname.lvs.report
   * Layout name: cellname.calibre.db (layout database)
   * Creation time            
   * Current directory         
   * User name              
   * Calibre version
4. `cellname.lvs.report` : It is the LVS report file(command in rule file is " LVS REPORT : cellname.lvs.report " which in addition to the info mentioned in cellname.lvs.report.ext has the following data:
   * Source name: cellname.src.net
   * Rule file and rule file title
   * Overall comparison results
   * Cell summary
   * LVS parameters
   * Cell comparison results
   * Information and warnings
   * Summary
5. `lvs.summary` : It is the LVS Summary report as mentioned in the rule file as " LVS SUMMARY REPORT : lvs.summary " which contains extraction and LVS comparison information like:
   * Start time and finish time of extraction and comparison.
   * Extraction and comparison report file names : `cellname.lvs.report.ext` and `cellname.lvs.report` respectively
   * Extracted SPICE Netlist path and file name : `cellname.sp`
   * LVS comparison status (correct/incorrect)
 



