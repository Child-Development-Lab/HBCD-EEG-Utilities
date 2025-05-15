#Tutorial

## Download EEG data from Lasso 

Please see the central [HBCD Data Release Docs](https://hbcd-docs.readthedocs.io/data_access/) for instructions to access and download HBCD data.

When downloading EEG data from Lasso, ensure you download the ``scans.tsv`` file from the "Raw Data" tab of the File transfer interface in addition to the EEG made processed data you wish to use. The ``scans.tsv`` file is necessary to run HBCD_EEG_Utilities.m 

## Running the script 

Please make sure to set up matlab, EEGLAB, and Github folder before running the script. To set up these softwares, visit the 'Installation' tab on the left. 

1. Open `HBCD-EEG-Utilities.m` and press the green 'Run' button on the 'Editor' toolbar. To open the `HBCD-EEG-Utilities.m`, double click on the file.

2. Follow the prompts to select the file path to the ``rawdata`` and ``derivatives/made`` folders downloaded from Lasso. If prompted, select the path to where you downloaded EEGLAB. Then, select the tasks for which you wish to compute derivatives. 

3. Wait for the script to finish. This could take up to 2 hours if processing all tasks for all release subjects. 

4. Find derivative output in the output location you selected. 


