# Usage

## `HBCD-EEG-Utilities.m`

This script's functionality is as follows:

- Loads HBCD EEG .set files
- Computes derivatives for each task.
- Saves trial-level and summary statistics output per participant, per task.
- Relabels summary statistics to reflect names of ERP components and ROIs of interest.
- Concatenates all summary statistics output into a single spreadsheet per task. 

To use this script: 

1. Open the script using MATLAB.
2. Provide a directory path (the path to the folder where the downloaded EEG data is stored; instructions for how to navigate to this folder are on the installation page) on line 18. *Be sure your directory path ends in a '/', to ensure the files are written to the correct location with the correct file name*

NOTE: if you are using this script on a Windows computer, you will need to change the direction of the slashes from '\\' to '/'.

3. Provide an output path (the path to the folder where you would like the outputs to end up) on line 19. *Be sure your output path ends in a '/', to ensure the files are out put to the correct location with the correct file name*

NOTE: if you are using this script on a Windows computer, you will need to change the direction of the slashes from '\\' to '/'.

4. At the top right of the script, click the down arrow next to the "Run" icon. 
5. At the bottom of the list, click "Run All" 
6. Your output sheets can be seen in the folder provided on line 23.

