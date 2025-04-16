# Usage

## concatenate_files_summary.Rmd
This script concatenate all summary statistics (SME, and power for RS) across participants and outputs a sheet for the Resting State, FACE, MMN, and VEP Tasks. The output relabels these statistics to reflect the ERP components and ROIs of interest, and is separated by task.

To use this script: 
1. Open the script using RStudio. 
2. Provide a directory path (the path to the folder where the downloaded EEG data is stored; instructions for how to navigate to this folder are above) on line 18. *Be sure your directory path ends in a '/', to ensure the files are out put to the correct location with the correct file name*

NOTE: if you are using this script on a Windows computer, you will need to change the direction of the slashes from '\\' to '/'.

3. Provide an output path (the path to the folder where you would like the outputs to end up) on line 19. *Be sure your output path ends in a '/', to ensure the files are out put to the correct location with the correct file name*

NOTE: if you are using this script on a Windows computer, you will need to change the direction of the slashes from '\\' to '/'.

4. At the top right of the script, click the down arrow next to the "Run" icon. 
5. At the bottom of the list, click "Run All" 
6. Your output sheets can be seen in the folder provided on line 23.


## concatenate_files_trialmeasures.Rmd
This script concatenates all ERP relevant mean amplitudes at the individual trial level across participants for the FACE and MMN Tasks.

To use this script: 
1. Open the script using RStudio. 
2. Provide a directory path (the path to the folder where the downloaded EEG data is stored; instructions for how to navigate to this folder are above) on line 22. *Be sure your directory path ends in a '/', to ensure the files are out put to the correct location with the correct file name*

NOTE: if you are using this script on a Windows computer, you will need to change the direction of the slashes from '\\' to '/'.

3. Provide an output path (the path to the folder where you would like the outputs to end up) on line 23. *Be sure your directory path ends in a '/', to ensure the files are out put to the correct location with the correct file name*

NOTE: if you are using this script on a Windows computer, you will need to change the direction of the slashes from '\\' to '/'.

4. At the top right of the script, click the down arrow next to the "Run" icon. 
5. At the bottom of the list, click "Run All" 
6. Your output sheets can be seen in the folder provided on line 23.



Descriptions of each task's ERP components, time windows (by age), and ROI are available in the excel file on the GitHub repository, and below: 

| Task | Component | Time window | ROI  | Age |
|------|-----------|-------------|------|-----|
| MMN  | MMR       | 200-400     | t7t8 | 3-9 |
| MMN  | MMR       | 200-400     | f7f8 | 3-9 |
| MMN  | MMR       | 200-400     | fcz  | 3-9 |
| MMN  | N1        | 40-79       | t7t8 | 3-9 |
| MMN  | P1        | 80-100      | t7t8 | 3-9 |
| MMN  | N2        | 100-180     | t7t8 | 3-9 |
| FACE | N290      | 200-350     | p8   | 3-6 |
| FACE | P1        | 75-125      | oz   | 3-6 |
| FACE | N290      | 250-350     | oz   | 3-6 |
| FACE | P400      | 355-625     | oz   | 3-6 |
| FACE | N290      | 250-300     | p8   | 6-9 |
| FACE | P1        | 75-125      | oz   | 6-9 |
| FACE | N290      | 250-300     | oz   | 6-9 |
| FACE | P400      | 325-625     | oz   | 6-9 |
| FACE | Nc        | 300-650     | FCz  | 3-9 |
| VEP  | N1        | 40-79       | oz   | 3-6 |
| VEP  | P1        | 80-140      | oz   | 3-6 |
| VEP  | N2        | 141-300     | oz   | 3-6 |
| VEP  | N1        | 40-79       | oz   | 6-9 |
| VEP  | P1        | 80-120      | oz   | 6-9 |
| VEP  | N2        | 121-170     | oz   | 6-9 |
