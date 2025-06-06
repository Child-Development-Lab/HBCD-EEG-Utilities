#Usage & Tutorial

## Required BIDS Input Data

Required inputs are ``scans.tsv`` files and EEG ``.set`` and ``.fdt`` files for each subject. See [here](https://hbcd-eeg-utilities.readthedocs.io/en/latest/downloading-data/) for instructions to download these files.

## Execution in Matlab

1- Install HBCD-EEG-Utilities and its dependencies: see [Installation](https://hbcd-eeg-utilities.readthedocs.io/en/latest/installation/).

2- Open `HBCD-EEG-Utilities.m` by double-clicking the file, and press the green 'Run' button on the 'Editor' toolbar.

 ![Press Run](Run.png)
 
3- Select file path to ``derivatives/made`` folder downloaded from Lasso. This folder contains eeg ``.set`` files.
 ![dirs derivatives](selectdir_derivatives.png)

4- Select file path to the ``rawdata`` folder downloaded from Lasso. This folder contains ``scans.tsv `` files. 
 ![dirs raw](selectdir_raw.png)

5- If prompted, select the path to where you downloaded EEGLAB. 

6- Select the tasks for which you wish to compute derivatives. 
 ![task selection](taskselect.png)

7- Wait for the script to finish. **This could take up to 2 hours if processing all tasks for all release subjects.**

8- Find derivative output in the following folders:
 
    |__ made/
        |__ sub-<label>/ #subject-level output
        |__ Concatenated outputs for ERPs/ #concatenated output
            
See [Descriptions of output](https://hbcd-eeg-utilities.readthedocs.io/en/latest/expected-outputs/) for details. 