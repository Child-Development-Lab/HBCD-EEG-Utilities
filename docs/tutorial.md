#Tutorial

## Download EEG data from Lasso 

Add link to instructions for Lasso data transfer

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
