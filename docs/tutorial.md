#Tutorial

## Download EEG data from Lasso 

Please see the central (HBCD Data Release Docs)[https://hbcd-docs.readthedocs.io/data_access/] for instructions to access and download HBCD data.

When downloading EEG data from Lasso, ensure you download the ``scans.tsv`` file from the "Raw Data" tab of the File transfer interface. This file is necessary to run HBCD_EEG_Utilities.m 

## Running the script 

1. Open `HBCD-EEG-Utilities.m` and enter the path to the EEG data as the directory path. 
The directory path should end in `bids\derivatives\made` in accordance with the following folder structure of the data transfer from Lasso. 

```{r}

|__ hbcd/
    |__ rawdata/ 
    |__ derivatives/ 
        |__ made/
            |__ xyz #input data
            |__ abc #output data 

```
2. Specify the output path you wish to use for the final .csv output files containing all subjects' data

For example: 

```{r}
directory_path = 'C:\Documents\bids\derivatives\made'
output_path = 'C:\Documents\ %desired output location'
```
3. Press 'Run' 

4. Wait for script to finish

5. Find output in 
