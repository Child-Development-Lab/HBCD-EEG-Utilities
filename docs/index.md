# HBCD EEG Utilities

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15483799.svg)](https://doi.org/10.5281/zenodo.15483799)

The [HBCD EEG Utilities](https://github.com/Child-Development-Lab/HBCD-EEG-Utilities) repository contains `HBCD-EEG-Utilities.m`, a MATLAB script that computes EEG derivatives from HBCD EEG .set files that have been processed with the HBCD-MADE pipeline. 

This script is designed for users of HBCD EEG data who wish to use derivatives developed by the HBCD EEG Working Group. See [Derivatives and ERP Specifications](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/derivatives_ERPspecs/) for a description of outputs.  

`HBCD_EEG_Utilities.m` calls on a series of functions contained in `HBCD-EEG-Utilities/supplemental files`.
Functionality of the software is as follows:

- Load HBCD EEG .set files 
- Computes [derivatives](https://hbcd-eeg-utilities.readthedocs.io/en/latest/derivatives_ERPspecs/) for each selected task 
- Saves trial-level and summary statistics output per participant for the VEP, MMN, and FACE tasks 
- Saves power spectrum output for the RS task 
- Writes subject-level summary statistics and trial measures output tables as .csv files 
- Concatenates all subjects' summary statistics output into a single spreadsheet for each task 
- Concatenates all subjects' trial measures output into a single spreadsheet for each task

## Functionality

The following MATLAB scripts and .json files in the HBCD-EEG-Utilities repository are required for processing. 

    |__ HBCD-EEG-Utilities/
        |
        |__ HBCD_EEG_Utilities.m #load data, compute mean amplitude, generate output tables
        |
        |__ supplemental files/
            |
            |__compute_peaks_latencies.m #compute adaptive mean and latency measures for VEP
            |__concatenate_files_summary.m #combine all subjects' summary statistics into one .csv
            |__concatenate_trial_measures.m #combine all subjects' trial data into one .csv
            |__get_Cluster.m #define clusters used for ROIs
            |__grab_settings.m #read in processing settings from proc_settings_HBCD.json
            |__RS_ERP_Topo_Indv.m #calculates power values for RS and save output to .csv files
            |
            |__proc_settings_HBCD.json #specify processing settings
            
            
### Contents 

- [Installation](https://hbcd-eeg-utilities.readthedocs.io/en/latest/installation/)
- [Derivatives and ERP Specifications](https://hbcd-eeg-utilities.readthedocs.io/en/latest/derivatives_ERPspecs/)
- [Expected Outputs](https://hbcd-eeg-utilities.readthedocs.io/en/latest/expected-outputs/)
- [Tutorial](https://hbcd-eeg-utilities.readthedocs.io/en/latest/tutorial/)
- [Help](https://hbcd-eeg-utilities.readthedocs.io/en/latest/help/)