 Expected Outputs

## Derivatives

# The following derivatives are provided for each task

| Task | Derivative     |
|------|----------------|
| FACE | SME            |
| FACE | Mean amplitude |
| MMN  | SME            |
| MMN  | Mean amplitude |
| MMN  | Adaptive mean  |
| MMN  | Peak latency   |
| VEP  | SME            |
| VEP  | Mean amplitude |
| VEP  | Adaptive mean  |
| VEP  | Peak latency   |
| RS   | Power          |

## ERP specifications

# ERP derivatives contain the following components at the specified time windows and ROIs. 

| Task | Component | Time window | ROI  | Age |
|------|-----------|-------------|------|-----|
| MMN  | MMR       | 200-400 ms    | t7t8 | 3-9 |
| MMN  | MMR       | 200-400 ms    | f7f8 | 3-9 |
| MMN  | MMR       | 200-400 ms    | fcz  | 3-9 |
| MMN  | N1        | 40-79 ms      | t7t8 | 3-9 |
| MMN  | P1        | 80-100 ms     | t7t8 | 3-9 |
| MMN  | N2        | 100-180 ms    | t7t8 | 3-9 |
| FACE | N290      | 200-390 ms    | p8   | 3-6 |
| FACE | N290      | 200-390 ms    | p7   | 3-6 |
| FACE | N290      | 400-600 ms    | oz   | 3-6 |                              
| FACE | P400      | 355-625 ms    | oz   | 3-6 |                              
| FACE | N290      | 200-340 ms    | p8   | 6-9 |                           
| FACE | N290      | 200-340 ms    | p7   | 6-9 |                             
| FACE | P1        | 75-125 ms     | oz   | 6-9 |
| FACE | N290      | 200-340 ms    | oz   | 6-9 |
| FACE | P400      | 350-600 ms    | oz   | 6-9 |
| FACE | Nc        | 300-650 ms    | FCz  | 3-9 |
| VEP  | N1        | 40-79 ms      | oz   | 3-6 |
| VEP  | P1        | 80-140 ms     | oz   | 3-6 | 
| VEP  | N2        | 141-300 ms    | oz   | 3-6 |
| VEP  | N1        | 40-79 ms      | oz   | 6-9 |
| VEP  | P1        | 80-120 ms     | oz   | 6-9 |
| VEP  | N2        | 121-170 ms    | oz   | 6-9 |
| RS   | N/A       | 1000 ms epochs| all channels   | 3-9 | power |


## Output files

For each task, two .csv files are automatically produced by MADE: a trial measures file and a summary statistics file.

Click :download:`here <csv_data_dictionary.csv>` to download a data dictionary defining the fields in each .csv output file. 

### ``trialMeasures.csv`` files are created for MMN, VEP, and FACE and contain the following output variables for each trial retained after processing: 

MeanAmplitude
: Mean amplitude during specified measurement window

AvgPeak
: The average peak, or adaptive mean peak, is calculated by finding the peak during the specified time window and averaging the amplitude across all sampling points within 1 standard deviation of the peak. 

Latency
: Latency in ms to the peak amplitude during the specified time window

	
### ``summaryStats.csv`` files are created for each task and contain the following output variables: 

SME
: Standard Measurement error. The SME is a universal measure of data quality for ERP data. See [Luck2021]_ for more information.

Mean_Power
: mean power at each frequency bin ranging from 1-50Hz

# Output by task 

## FACE 

### FACE Trial Measures Output: `filename.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | inverted, object, uprightInv, uprightObj |
| TrialNum | number of trials retained per condition |
| MeanAmplitude_<WindowStart-WindowEnd>_<ROI> | Mean amplitude within specified time window at specified ROI |


 ### FACE Summary Statistics Output: `filename.csv`
 
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | inverted, object, uprightInv, uprightObj |
| NTrials | number of trials retained per condition |
| SME_<WindowStart-WindowEnd>_<ROI> | Standard measurement error during specified time window at specified ROI |


## MMN

### MMN Trial Measures Output: `filename.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | deviant, predeviant, standard |
| TrialNum | number of trials retained per condition |
| MeanAmplitude_<WindowStart-WindowEnd>_<ROI> | Mean amplitude within specified time window at specified ROI |
| Peak_<WindowStart-WindowEnd>_<ROI> | Adaptive mean amplitude within specified time window at specified ROI |
| Latency_<WindowStart-WindowEnd>_<ROI> | Latency to peak within specified time window at specified ROI |

### MMN Summary Statistics Output: `filename.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | deviant, predeviant, standard |
| NTrials | number of trials retained per condition |
| SME_<WindowStart-WindowEnd>_<ROI> | Standard measurement error during specified time window at specified ROI |


## Visual Evoked Potential  

### VEP Trial Measures Output: `filename.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | VEP |
| TrialNum | number of trials retained per condition |
| MeanAmplitude_<WindowStart-WindowEnd>_<ROI> | Mean amplitude within specified time window at specified ROI |
| Peak_<WindowStart-WindowEnd>_<ROI> | Adaptive mean amplitude within specified time window at specified ROI |
| Latency_<WindowStart-WindowEnd>_<ROI> | Latency to peak within specified time window at specified ROI |

## VEP Summary Statistics Output: `filename.csv`

| Variable Name | Description                              |
|---------------|------------------------------------------|
| Condition | VEP |
| NTrials | number of trials retained per condition |
| SME_<WindowStart-WindowEnd>_<ROI> | Standard measurement error during specified time window at specified ROI |

## Resting State 

### RS Summary Statistics Output: `rs_SummaryStats.csv`
   
| Variable Name | Description                              |
|---------------|------------------------------------------|
| Frequency | 1 Hz bins from 1-50 Hz |
| SME | Standard Measurement Error in each frequency bin |
| Mean_Power | Global average power in each frequency bin |
| ID | subject ID |


