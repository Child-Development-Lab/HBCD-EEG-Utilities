# HBCD EEG Utilities

The [HBCD EEG Utilities](https://github.com/Child-Development-Lab/HBCD-EEG-Utilities) repository contains `HBCD-EEG-Utilities.m`, a MATLAB script that computes EEG derivatives from HBCD EEG .set files and writes the output to .csv files. 

This script is designed for users of HBCD EEG data who wish to use derivatives developed by the EEG Working Group. See [Derivatives and ERP Specifications](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/derivatives_ERPspecs/) for a description of outputs.  


Functionality of `HBCD-EEG-Utilities.m` is as follows:

- Loads HBCD EEG .set files
- Computes derivatives for each task.
- Saves trial-level and summary statistics output per participant, per task.
- Relabels summary statistics to reflect names of ERP components and ROIs of interest.
- Concatenates all summary statistics output into a single spreadsheet per task. 

### Contents 

- [Installation](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/installation/)
- [Usage](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/usage/)
- [Derivatives and ERP Specifications](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/derivatives_ERPspecs/)
- [Expected Outputs](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/expected-outputs/)
- [Help](https://childdevlab-hbcd-eeg-utilities.readthedocs.io/en/latest/help/)