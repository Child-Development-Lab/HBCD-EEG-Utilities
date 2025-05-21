# HBCD EEG Utilities

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15483799.svg)](https://doi.org/10.5281/zenodo.15483799)

The [HBCD EEG Utilities](https://github.com/Child-Development-Lab/HBCD-EEG-Utilities) repository contains `HBCD-EEG-Utilities.m`, a MATLAB script that computes EEG derivatives from HBCD EEG .set files that have been processed with the HBCD-MADE pipeline. 

This script is designed for users of HBCD EEG data who wish to use derivatives developed by the HBCD EEG Working Group. See [Derivatives and ERP Specifications](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/derivatives_ERPspecs/) for a description of outputs.  


Functionality of `HBCD-EEG-Utilities.m` is as follows:

- Loads HBCD EEG .set files
- Computes derivatives for each selected task.
- Saves trial-level and summary statistics output per participant for the VEP, MMN, and FACE tasks.
- Saves power spectrum output for the RS task. 
- Relabels variable names to reflect names of ERP components and ROIs of interest.
- Concatenates all subjects' summary statistics output into a single spreadsheet for each task. 
- Concatenates all subjects' trial measures output into a single spreadsheet for each task. 

### Contents 

- [Installation](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/installation/)
- [Usage](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/usage/)
- [Derivatives and ERP Specifications](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/derivatives_ERPspecs/)
- [Expected Outputs](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/expected-outputs/)
- [Help](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/help/)