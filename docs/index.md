# HBCD EEG Utilities

README instructions and scripts for working with the EEG data in the March 1 HBCD public data release.

These instructions will allow the user to extract a full derivative dataset (of summary statistics and trial measures) from the subject-level file based download, found under "Query Data" > "Download File Based Data" on the Lasso interface. For instructions on how to download data on the Lasso interface, please visit https://docs.hbcdstudy.org/ (This link will be updated when the data release is live) .

This repository contains 2 scripts: 
1. **concatenate_files_summary.Rmd**: This script will pull the summary statistics (or power, for RS) .csv for each subject and concatenate them into a single, task specific summary statistics/power .csv. 
2. **concatenate_files_trialmeasures.Rmd**: This script will pull the trial measures .csv for each subject and concatenate them into a single, task specific trial level .csv.


