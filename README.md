# verification
drc/lvs/pex

# Creating a new library
* Go to `File -> New -> New library` from the menu bar in schematic/layout window.
* Enter the library name in the library pop-up window that appears.
* The library's name will appear in the left side panel under libraries section.

# Creating a new cell in the library
* Go to `Cell -> New view` from the menu bar in schematic/layout window.
* Enter the library in which the cell has to be created.
* Enter the cell name and also the view type and view name.
* The cell's name will appear in the left side panel under cells section.

# Designing a schematic 
* Open the cell view window by clicking on the desired library and cell view name in the schematic editor.
* For placing an instance in the schematic, press `i` and select names of library, cell and view.
* Place the instance in the schematic/layout window and then press `done` in the instance pop-up window.
  - (**NOTE** - *First place the instance, then press done. Done not to be clicked before placing*)
* The ports and wire are present in the icon panel and can be used when clicked on the icon once.
* For knowing the properties of the instance, click on the instance and the properties appear on the right side panel.

# Layout (L-Edit)
* When opening the Layout for the first time, you need to select a **Top Library** which ideally should be the parent library of the cell you are editing.
* To setup the **Technology** reference to L-Edit (setup for one time only): 
    * Select `Setup -> Technology Reference` which will open a dialogbox:
    * Drop down **OpenAccess attached Library** for *Technology Reference* and
    * choose **TECH_XT018** and move it to *Attached library* pane.
* To check if it was read properly, on the left pane where you browse the Library, click on the `Layer Palette` tab and make sure you can see all layers and their corresponding *numbers*.

# Generating a layout from a schematic
* In the layout editor, the library name under which the schematic has been designed will appear but the cell name would not appear.
* Create a cell following the steps mentioned above [Creating a new cell](#Creating-a-new-cell-in-the-library) with the **Same Name as in Schematic Window**.
* In the schematic editor, click on the `Publish to SDL` icon from the icon menu.
* In the layout editor, the cell whose layout has to be generated has to be selected and the layout appears.

# DRC/LVS (Calibre on Local Linux Host)
**NOTE** The following instructions are for running Calibre on the Linux host. To run verification on Windows, a SSH tunnel to the Linux host has to be created using PuTTy and a network drive has to be setup to share between the Windows and Linux host. 

* Create a folder each for DRC, LVS and PEX in your project directory. All the files generated while running DRC,LVS and PEX checks along with the runset files will be saved in their respective folders to make things cleaner and easily accessible.
```bash
cd /../YourProjectDirectory/
mkdir {DRC,LVS,PEX}

```
## DRC
  * Setup the server and path to Calibre. Click the **Settings** button (Spanner icon) next to `Calibre Toolbar (DRC/LVS/PEX/RVE/Settings)`:
    * For the host enter: `192.168.6.50`
    * For `calibre` give the entire path to the current tool: 
      * `$CALIBRE_HOME/bin/calibre`
  * In L-Edit, click **Run Calibre DRC** from the Calibre toolbar which will launch the GUI.
  * If the `Load Runset File` dialog box appears, you can **Cancel** it.
  * In the GUI, click the **Rules** button in the left Panel and enter the following info:
    * `DRC Rules File`: Browse to the Calibre rule file eg.
      * `$XFAB_CALIBRE_RUNSET/xt018_1243` You can click **Load** to test any problem with the rule file.
    * `Check Selection Recipe`: Ignore
    * `DRC Run Directory`: Ideally `$PROJDIR/DRC`
  * Click `Inputs` and setup the inputs but the defaults should be Ok eg. GDSII/Export from Layout Viewer
  * Click `Outputs` and the defaults should be fine.
  * If none of the left panel buttons are red, click **Run DRC**
  * If the run was successful, save the GUI settings to a file by clicking `File->Save Runset` in the DRC folder created before which can be loaded the next time.

## LVS
  * In L-Edit, click **Run Calibre LVS** from the Calibre toolbar which will launch the GUI.
  * If the `Load Runset File` dialog box appears, you can **Cancel** it.
  * In the GUI, click the **Rules** button in the left Panel and enter the following info:
    * `LVS Rules File`: Browse to the Calibre rule file eg.
      * `$XFAB_CALIBRE_RUNSET/xt018_1243`
    * `LVS Run Directory`: Ideally `$PROJDIR/LVS`
  * Click **Inputs** and set up the **Run**, **Step**, and **Layout** tab information. Settings may be  correct by default:
    * Select **Layout vs Netlist** from the Step dropdown menu.
    * Enable **Export from layout viewer** on the **Layout** tab.
    * Select **GDSII** in the Format dropdown list.
  * Click the **Netlist** tab on the `Inputs` pane to set up schematic (source) input.
    * Enable **Export from schematic viewer**. **NOTE**: If you want to LVS with netlist from another cell, open that cell in S-Edit and it will netlist that cell. If a netlist exists and you want to LVS wrt that netlist then deselect that this button.
    * Select **SPICE** from the Format dropdown list.
  * Click **Outputs** and enable **View Extraction Report** after LVS finishes and Start RVE after LVS finishes.
  * Click **Run LVS**.
  * If the run was successful, save the GUI settings to a file by clicking `File->Save Runset` in the LVS folder created before which can be loaded the next time.
  
# Examples
  1. Two-terminal device - [Resistor](https://github.com/prachi-mrudula/verification/tree/main/Resistor)
      * The rule file was written by deducting from the main rule file and then netlisting and LVS verification were performed.
  The rule file has a MACRO section init to calculate `W and L` of resistor. So, to get an insight into MACRO, the following exercises(2 and 3) were done:
  2. Macro for rectangular shaped resistor using perimeter function which has no bends: - [Res_macro] 
  3. Serpentine 90 shape resistor which has bends: - [ser_90_res]
      * Netlisting and LVS were performed.
      * Verified modified Macro definition with bends function included using perimeter function instead of area.
      * Calculated the percentage error of length calculation from macro definition between:
  
        |Paramter| macro definition considering bends(um) | macro definition without considering bends(simple)(um) |
        |------|------------------------------------|----------------------------------------------------|
        | Length | 307.62               |   315.62                             |

        when `Resistance = 50k ohm`, `Width = 2um`, `No. of bends:- 8`, `No. of strips:- 5`.
      * Thus, **% error = 2.6%** 
          ``` bash 
               error % = {((315.62-307.62)/307.62) * 100} 
          ```
  The effect of strip length on parameters of resistor have been studied from the next example(4).
  
  4. Strip length comparison for serpentine 90 resistors:- [ser_res_test]
      * Two resistors (serpentine 90) with different strip lengths are netlisted and LVS performed.
      * Permute the % error of lengths for both of these resistors considering with and without nends macro definition.
      * Compare the error % of length obtained for both the resistors.
        | Parameter      | 1st resistor   | 2nd resistor    |
        |----------------|----------------|-----------------|
        | No. of Strips  | 32             |  8              |
        | Resistance     | 60.3653k ohm   | 60.3653k ohm    |
        | Strip Length   | 100um          | 461.56um        |
        | Width          | 20um           | 20um            |
        | Length considering no bends in macro definition| 0.00449656 | 0.00401656    | 
        | Length considering bends in macro definition| 0.00387656 | 0.00387656    |
        | % error        | 15.9%          | 3.6%            |
        
       * Thus, **error is less in resistor with greater strip length**.
       
   5. Custom resistor layout and netlisting :- [res_quad]
      * The shape of the resistor is: 
      * The spice netlist of the poly resistor is generated after the layout passes DRC. 
      * The calibre.db is extracted by `File` -> `Export Mask Data` -> `GDSII` in the GUI Leditor and is further used as input when netlisting.
      * Since, its for rnp1, the src.net for rnp1  is copied from a previously run test folders and renamed as filename.src.net.
      * For calculating the number of bends, macro definition for area with and without bends are considered and thus the parameters noted down and calculated.
          |Paramter| macro definition considering bends(um) | macro definition without considering bends(simple)(um) |
          |------|------------------------------------|----------------------------------------------------|
          | Length | 4.75878              |   4.75878                             |
          | Width  | 2.51341  | 6.0825 |
         Formula for number of bends:-
         ```bash
           width(with bends) = width(without bends) - (0.5 * no. of bends * length)
         => 2.52341 = 6.0825 -(0.5 * no. of bends * 4.75878)
         => no. of bends = 1.5
         ```
   The number of bends calculated is verified by another example(6):-
   6. Serpentine 45 resistor :- [ser_45_test]
      * Netlisting and LVS were performed.
      * Number of bends were calculated using the formula above and thus verified that 45 degree angle is being considered as bends = 0.5.
          |Paramter| macro definition considering bends(um) | macro definition without considering bends(simple)(um) |
          |------|------------------------------------|----------------------------------------------------|
          | Length | 61.1674              |   63.1674                             |
          | Width  | 2.0  | 2.0 |
         Formula for number of bends:-
         ```bash
           length(with bends) = length(without bends) - (0.5 * no. of bends * width)
         => 61.1674 = 63.1674 -(0.5 * no. of bends * 2.0)
         => no. of bends = 2
         ```
  
   
  
  
