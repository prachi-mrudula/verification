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
* Place the instance in the schematic/layout window and then press `done` in the instance pop-up window.(**NOTE** *First place the instance then press done not before placing*)
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
* Create a cell following the steps mentioned above [Creating a new cell](#Creating-a-new-cell-in-the-library) with the **same name as in schematic window**.
* In the schematic editor, click on the `Publish to SDL` icon from the icon menu.
* In the layout editor, the cell whose layout has to be generated has to be selected and the layout appears.

# DRC/LVS (Calibre on Local Linux Host)
**NOTE** The following instructions are for running Calibre on the Linux host. To run verification on Windows, a SSH tunnel to the Linux host has to be created using PuTTy and a network drive has to be setup to share between the Windows and Linux host. 

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
  * If the run was successful, save the GUI settings to a file by clicking `File->Save Runset` which can be loaded the next time.

## LVS
  * In L-Edit, click **Run Calibre LVS** from the Calibre toolbar which will launch the GUI.
  * If the `Load Runset File` dialog box appears, you can **Cancel** it.
  * In the GUI, click the **Rules** button in the left Panel and enter the following info:
    * `LVS Rules File`: Browse to the Calibre rule file eg.
      * `$XFAB_CALIBRE_RUNSET/xt018_1243`
    * `LVS Run Directory`: Ideally `$PROJDIR/DRC`
  * Click **Inputs** and set up the **Run**, **Step**, and **Layout** tab information. Settings may be  correct by default:
    * Select **Layout vs Netlist** from the Step dropdown menu.
    * Enable **Export from layout viewer** on the **Layout** tab.
    * Select **GDSII** in the Format dropdown list.
  * Click the **Netlist** tab on the `Inputs` pane to set up schematic (source) input.
    * Enable **Export from schematic viewer**. **NOTE**: If you want to LVS with netlist from another cell, open that cell in S-Edit and it will netlist that cell. If a netlist exists and you to LVS wrt that netlist then deselect that this button.
    * Select **SPICE** from the Format dropdown list.
  * Click **Outputs** and enable **View Extraction Report** after LVS finishes and Start RVE after LVS finishes.
