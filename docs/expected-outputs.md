# Expected Outputs from `script_name.m`

`script_name.m` will write the following output files: 

 
        `|__ outputdir/
            |
            | # FACE
            |__ sub-<ID>_ses-V03_task-FACE-ERPSummaryStats.csv
            |__ sub-<ID>_ses-V03_task-FACE-ERPTrialMeasures.csv
            |
            | # MMN
            |__ sub-<ID>_ses-V03_task-MMN-ERPSummaryStats.csv
            |__ sub-<ID>_ses-V03_task-MMN-ERPTrialMeasures.csv
            |
            | # VEP
            |__ sub-<ID>_ses-V03_task-VEP-SummaryStats.csv
            |__ sub-<ID>_ses-V03_task-VEP-ERPTrialMeasures.csv
            |
            | # RS
            |__ sub-<ID>_ses-V03_task-RS-PowerSummaryStats.csv`

## Output file descriptions

Click [here](https://github.com/Child-Development-Lab/HBCD-EEG-Utilities/blob/main/docs/csv_data_dictionary_derivatives.csv) to see a data dictionary defining the fields in each .csv output file. 

- ``trialMeasures.csv`` files are created for MMN, VEP, and FACE

- ``summaryStats.csv`` files are created for all tasks
          
# Output by task 

### FACE 

FACE Trial Measures Output
`sub-<ID>_ses-V03_task-FACE-ERPTrialMeasures.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | inverted, object, uprightInv, uprightObj |
| TrialNum | number of trials retained per condition |
| MeanAmplitude_WindowStart-WindowEnd_ROI | Mean amplitude within specified time window at specified ROI |


FACE Summary Statistics Output
`sub-<ID>_ses-V03_task-FACE-ERPSummaryStatistics.csv`
 
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | inverted, object, uprightInv, uprightObj |
| NTrials | number of trials retained per condition |
| SME_WindowStart-WindowEnd_ROI | Standard measurement error during specified time window at specified ROI |


### MMN

MMN Trial Measures Output
`sub-<ID>_ses-V03_task-MMN-ERPTrialMeasures.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | deviant, predeviant, standard |
| TrialNum | number of trials retained per condition |
| MeanAmplitude_WindowStart-WindowEnd_ROI | Mean amplitude within specified time window at specified ROI |
| Peak_WindowStart-WindowEnd_ROI | Adaptive mean amplitude within specified time window at specified ROI |
| Latency_WindowStart-WindowEnd_ROI | Latency to peak within specified time window at specified ROI |

MMN Summary Statistics Output
`sub-<ID>_ses-V03_task-MMN-ERPSummaryStatistics.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | deviant, predeviant, standard |
| NTrials | number of trials retained per condition |
| SME_WindowStart-WindowEnd_ROI | Standard measurement error during specified time window at specified ROI |


### Visual Evoked Potential  

VEP Trial Measures Output
`sub-<ID>_ses-V03_task-VEP-ERPTrialMeasures.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | VEP |
| TrialNum | number of trials retained per condition |
| MeanAmplitude_WindowStart-WindowEnd_ROI | Mean amplitude within specified time window at specified ROI |
| Peak_WindowStart-WindowEnd_ROI | Adaptive mean amplitude within specified time window at specified ROI |
| Latency_WindowStart-WindowEnd_ROI | Latency to peak within specified time window at specified ROI |

VEP Summary Statistics Output
`sub-<ID>_ses-V03_task-VEP-ERPSummaryStatistics.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | VEP |
| NTrials | number of trials retained per condition |
| SME_WindowStart-WindowEnd_ROI | Standard measurement error during specified time window at specified ROI |

### Resting State 

RS Summary Statistics Output
`sub-<ID>_ses-V03_task-RS-PowerSummaryStats.csv`
   
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Frequency | 1 Hz bins from 1-50 Hz |
| SME | Standard Measurement Error in each frequency bin |
| Mean_Power | Global average power in each frequency bin |
| ID | subject ID |


