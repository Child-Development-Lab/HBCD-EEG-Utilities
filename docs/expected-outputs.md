# Expected Outputs from `HBCD_EEG_Utilities.m`

`HBCD_EEG_Utilities.m` will write the following output files: 

 
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

RS Log Power Spectra Output
`sub-<ID>_ses-V03_task-RS-LogPowerSpectra.csv`
   
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Row | Electrode |
| 1.0 Hz | Sum of natural log power in μV^2^/Hz centered at 1 Hz (within the 0.5hz to 1.5hz freq range) at corresponding electrode site |
| 2.0 Hz | Sum of natural log power in μV^2^/Hz centered at 2 Hz (within the 1.5hz to 2.5hz freq range) at corresponding electrode site |
| 3.0 Hz | Sum of natural log power in μV^2^/Hz centered at 3 Hz (within the 2.5hz to 3.5hz freq range) at corresponding electrode site |
| ... | and so on... |

RS Absolute Power Spectra Output
`sub-<ID>_ses-V03_task-RS-AbsPowerSpectra.csv`
   
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Row | Electrode |
| 1.0 Hz | Sum of absolute power in μV^2^/Hz centered at 1 Hz (within the 0.5hz to 1.5hz freq range) at corresponding electrode site	 |
| 2.0 Hz | Sum of absolute power in μV^2^/Hz centered at 2 Hz (within the 1.5hz to 2.5hz freq range) at corresponding electrode site	 |
| 3.0 Hz | Sum of absolute power centered at 3 Hz (within the 2.5hz to 3.5hz freq range) at corresponding electrode site |
| ... | and so on... |

RS dB Power Spectra Output
`sub-<ID>_ses-V03_task-RS-dbPowerSpectra.csv`
   
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Row | Electrode |
| 1.0 Hz | Sum of power in db centered at 1 Hz (within the 0.5hz to 1.5hz freq range) at corresponding electrode site	 |
| 2.0 Hz | Sum of power in db centered at 2 Hz (within the 1.5hz to 2.5hz freq range) at corresponding electrode site	 |
| 3.0 Hz | Sum of power in db centered at 3 Hz (within the 2.5hz to 3.5hz freq range) at corresponding electrode site	 |
| ... | and so on... |

RS Power Spectra .mat Output
`sub-<ID>_ses-V03_task-RS_spectra.mat`
   
| Variable Name | Description                              |
|---------------|------------------------------------------|
| avg_abs_pow | Average absolute power across epochs |
| avg_log_pow | Average natural log power across epochs |
| avg_db_pow | Average power in decibels (db) across epochs |
| all_abs_power | Chans x absolute power x epochs |
| all_log_power | Chans x log power x epochs |
| all_db_pow | Chans x dB power x epochs |
| epoch_level_abs_pow | Abs power for each epoch |
| epoch_level_log_pow | Log power for each epoch |
| epoch_level_db_pow | dB power for each epoch |
| channel locations | Channel locations |
| freqs | Frequency bins (1hz increments, 1-50hz) |
| n_epochs | Number of epochs |
| Fs | Sampling rate |
| num_channels | Number of channels |

