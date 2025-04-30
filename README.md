**HBCD-EEG-data-release-notes**

README instructions and scripts for working with the EEG data in the March 1 HBCD public data release.

These instructions will allow the user to extract a full derivative dataset (of summary statistics and trial measures) from the subject-level file based download, found under "Query Data" > "Download File Based Data" on the Lasso interface. For instructions on how to download data on the Lasso interface, please visit https://docs.hbcdstudy.org/ (This link will be updated when the data release is live) .

This repository contains 2 scripts: 
1. **concatenate_files_summary.Rmd**: This script will pull the summary statistics (or power, for RS) .csv for each subject and concatenate them into a single, task specific summary statistics/power .csv. 
2. **concatenate_files_trialmeasures.Rmd**: This script will pull the trial measures .csv for each subject and concatenate them into a single, task specific trial level .csv.
3. **Generate_csvs.m**: This script computes ERP derivatives for the FACE, MMN, and VEP tasks and writes the output to .csv files. See ‘(link) Expected Outputs’ for a description of the ERP derivatives. Generate_csvs.m calls two functions:

The user will need RStatistics and RStudio to be able to run these scripts. Below are instructions for downloading these interfaces. 

Download R software: 

To install R on Windows OS:

1. Go to the CRAN website (https://cran.r-project.org/).
2. Click on "Download R for Windows".
3. Click on "install R for the first time" link to download the R executable (.exe) file.
4. From your downloads folder, run the R executable file to start installation, and allow the app to make changes to your device.
5. Select the installation language.
6. Follow the installation instructions.
7. Click on "Finish" to exit the installation setup.
8. R has now been successfully installed on your Windows OS. Open the R GUI to start writing R codes.

Installing R on MacOS X:
Installing R on MacOS X is very similar to installing R on Window OS. The difference is the file format that you have to download. The procedure is as follows:

1. Go to the CRAN website (https://cran.r-project.org/).
2. Click on "Download R for macOS". 
3. Download the latest version of the R GUI under (.pkg file) under "Latest release". You can download much older versions by following the "old directory" or "CRAN archive" links. NOTE: if you have a mac that is operating on MacOS 12 or earlier, select the "For older Intel Macs" executable.
4. From your downloads folder, run the .pkg file, and follow the installation instructions.


Download RStudio: 

Installing RStudio Desktop:

1. Go to the RStudio website (https://posit.co/download/rstudio-desktop/).
2. Scroll down to the "All Installers and Tarballs" section. 
3. Click on the download link specific to your operating system (OS). 

NOTE: If you have Mac OS 12 or earlier, you will need to download an older, unsupported version of R Studio. Visit https://forum.posit.co/t/rstudio-desktop-releases-on-unsupported-versions-of-macos/176074 and select the installer that corresponds to your OS version.

4. From your downloads folder, run the RStudio Executable file (.exe) for Windows OS or the Apple Image Disk file (.dmg) for macOS X.
5. Follow the installation instructions to complete RStudio Desktop installation.
6. RStudio is now successfully installed on your computer.


Now that you have these software, you will be able to run the scripts on our repository to manipulate the provided participant level data. First, you will need to download the repository to your local computer. This can be done in a number of ways, but for a first time user we recommend downloading as a zip file. 

Downloading the GitHub repository: 

1. Scroll to the top of this repository. 
2. Next, click on the green "Code <>" button at the top right. 
3. From the dropdown menu, select "Download ZIP" at the bottom. This will download the entire repository to your downloads folder. 
4. Navigate to your downloads folder. Select the zipped "HBCD-EEG-data-release-notes-main" folder by left clicking. Right click. 
5. Select the "Extract all" option from the drop down menu. This will unzip the repository to your downloads folder. 

Now, we will outline how to navigate your folder structure. The EEG data will be downloaded to a folder within a folder of all other outputs you download off of Lasso. To navigate to the EEG data to be used in the below scripts, in your Lasso download, navigate to the "bids > derivatives > made" folder. This should be a folder with folders named "sub-{unique ID}". Use the path to this folder as the directory path in each of the provided R Studio scripts.

Now, you're ready to The following are instructions on how to run each of the provided scripts. 

1. **concatenate_files_summary.Rmd**:
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

2. **concatenate_files_trialmeasures.Rmd**:
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
| FACE | N290      | 200-390     | p8   | 3-6 |
| FACE | N290      | 200-390     | p7   | 3-6 |
| FACE | P1        | 75-125      | oz   | 3-6 |
| FACE | N290      | 400-600     | oz   | 3-6 |
| FACE | P400      | 355-625     | oz   | 3-6 |
| FACE | N290      | 200-340     | p8   | 6-9 |
| FACE | N290      | 200-340     | p7   | 6-9 |
| FACE | P1        | 75-125      | oz   | 6-9 |
| FACE | N290      | 200-340     | oz   | 6-9 |
| FACE | P400      | 350-600     | oz   | 6-9 |
| FACE | Nc        | 300-650     | FCz  | 3-9 |
| VEP  | N1        | 40-79       | oz   | 3-6 |
| VEP  | P1        | 80-140      | oz   | 3-6 |
| VEP  | N2        | 141-300     | oz   | 3-6 |
| VEP  | N1        | 40-79       | oz   | 6-9 |
| VEP  | P1        | 80-120      | oz   | 6-9 |
| VEP  | N2        | 121-170     | oz   | 6-9 |

Please direct any inquiries regarding this repository, use of the associated scripts, or the HBCD EEG data release to eegdata@umd.edu. 
Authorship for this repository is as follows: 
- Savannah McNair, smcnair1@umd.edu, @savmcnair (GitHub username)
- Trisha Maheshwari, tmahesh@umd.edu, @trisham16 (GitHub username)
- Whitney Kasenetz, kasenetz@umd.edu, @kasenetz (GitHub username) 
- Jess Norris, jnorri10@umd.edu, @jnorri10 (GitHub username) 
- Child Development Lab affiliates, @ChildDevLab (GitHub account)

To copy the full citation of this repository, click "Cite this repository" in the top right of the GitHub repository, under "About".

To see the preprocessing pipeline this EEG data was preprocessed with, see this reference: 

Debnath, R., Buzzell, G. A., Morales, S., Ashton, K., Antunez Garcia, M., Bowers, M. E., Kasenetz, W. E., Leach, S., Lee, E., Maheshwari, T., McNair, S., McSweeney, M., Norris, J., Yoder, L., & Fox, N. A. (2025). DCAN-Labs/HBCD-MADE: 1.5.2 (1.5.2). Zenodo. https://doi.org/10.5281/zenodo.14764666
