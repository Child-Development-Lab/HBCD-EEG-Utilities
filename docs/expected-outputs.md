# Expected Outputs from `HBCD-EEG-Utilities.m`

`HBCD-EEG-Utilities.m` will write the following output files: 

 
        |__ outputdir/
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
            |__ sub-<ID>_ses-V03_task-RS-LogPowerSpectra.csv
            |__ sub-<ID>_ses-V03_task-RS-AbsPowerSpectra.csv

## Descriptions of output

Click [here](https://github.com/Child-Development-Lab/HBCD-EEG-Utilities/blob/main/docs/csv_data_dictionary_derivatives.csv) to see a data dictionary defining the fields in each .csv output file. 

- ``trialMeasures.csv`` Derivatives are provided for each trial in MMN, VEP, and FACE.
- ``summaryStats.csv`` Derivatives are provided as subject-level averages for each task. For tasks with multiple conditions, values are averaged by condition. 

# Output by task 

### FACE 

FACE Trial Measures Output
`sub-<ID>_ses-V03_task-FACE-ERPTrialMeasures.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | inverted, object, uprightInv, uprightObj |
| TrialNum | trial index |
| MeanAmplitude_WindowStart-WindowEnd_ROI | Mean amplitude within specified time window at specified ROI |


FACE Summary Statistics Output
`sub-<ID>_ses-V03_task-FACE-ERPSummaryStatistics.csv`
 
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | inverted, object, uprightInv, uprightObj |
| NTrials | number of trials retained per condition |
| MeanAmplitude_WindowStart-WindowEnd_ROI | Mean amplitude within specified time window at specified ROI |
| SME_WindowStart-WindowEnd_ROI | Standard measurement error during specified time window at specified ROI |


### MMN

MMN Trial Measures Output
`sub-<ID>_ses-V03_task-MMN-ERPTrialMeasures.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | deviant, predeviant, standard |
| TrialNum | trial index |
| MeanAmplitude_WindowStart-WindowEnd_ROI | Mean amplitude within specified time window at specified ROI |

MMN Summary Statistics Output
`sub-<ID>_ses-V03_task-MMN-ERPSummaryStatistics.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | deviant, predeviant, standard |
| NTrials | number of trials retained per condition |
| MeanAmplitude_WindowStart-WindowEnd_ROI | Mean amplitude within specified time window at specified ROI |
| SME_WindowStart-WindowEnd_ROI | Standard measurement error during specified time window at specified ROI |


### Visual Evoked Potential  

VEP Trial Measures Output
`sub-<ID>_ses-V03_task-VEP-ERPTrialMeasures.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | VEP |
| TrialNum | trial index |
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
| MeanAmplitude_WindowStart-WindowEnd_ROI | Mean amplitude within specified time window at specified ROI |
| Peak_WindowStart-WindowEnd_ROI | Adaptive mean amplitude within specified time window at specified ROI |
| Latency_WindowStart-WindowEnd_ROI | Latency to peak within specified time window at specified ROI |

### Resting State 

RS Power Spectra Output
`sub-<ID>_ses-V03_task-RS-LogPowerSpectra.csv`
   
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Row | Electrode |
| 1.0 Hz | Log power in μV from 0.3-1 Hz |
| 2.0 Hz | Log power in μV from 1-2 Hz |
| 3.0 Hz | Log power in μV from 2-3 Hz |
| ... | and so on... |

`sub-<ID>_ses-V03_task-RS-AbsPowerSpectra.csv`
   
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Row | Electrode |
| 1.0 Hz | Absolute power in μV from 0.3-1 Hz |
| 2.0 Hz | Absolute power in μV from 1-2 Hz |
| 3.0 Hz | Absolute power in μV from 2-3 Hz |
| ... | and so on... |
