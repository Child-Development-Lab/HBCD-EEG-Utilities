#Tutorial

## Download EEG data from Lasso 

Add link to instructions for Lasso data transfer

## Running the script 

Open `HBCD-EEG-Utilities.m` and enter the path to the EEG data as the directory path. 
The path should end in `bids\derivatives\made` in accordance with the following folder structure of the data transfer from Lasso. 

```{r}
`
|__ hbcd/
    |__ rawdata/ 
    |__ derivatives/ 
        |__ made/
            |__ xyz #input data
            |__ abc #output data 

```

For example: 
`directory_path = 'C:\Documents\bids\derivatives\made`

Specify the output path you wish to use for the final .csv output files containing all subjects' data
`output_path = 'C:\Documents\ %desired output location`

