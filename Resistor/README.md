# Resistor(poly-resistor- rnp1)
* This folder contains the following subfiles/folders:

|         Inputs        |          Outputs          |
|-----------------------|---------------------------|
| res_test.calibre.db   |      netlist LAYOUT       |
| res_test.src.net      |      netlist SOURCE       |
| rule_file             |   res_test.lvs.report.ext |
| xt018_1243            |   res_test.lvs.report     |
| res_test.rul          |   svdb                    |
| res_test_final.rul    |                           |

## res_test.calibre.db 
* This is the layout database file generated from layout.
* It is generated on running LVS from the GUI mode.
* It can also be generated without running LVS. 
   * In the menu bar, go to `File`->`Export Mask Data`->`GDSII`. 
   * In the pop-up window that appears, in the `to File` section, give the path and the name of the file that you wish to save your layout database information in (here, the file name is: res_test.calibre.db).
   
## res_test.src.net 
* This file contains the netlist of the schematic (poly resistor).
* This is extracted from schematic on running LVS in GUI mode.(Export from schematic view)

## rule_file
* This is the first rule file containing all the output paths and 

