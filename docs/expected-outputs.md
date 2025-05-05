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

| Task | Component | Time window | ROI  | Age | Available derivatives                              |
|------|-----------|-------------|------|-----|----------------------------------------------------|
| MMN  | MMR       | 200-400 ms    | t7t8 | 3-9 | mean amplitude, adaptive mean, peak latency, SME |
| MMN  | MMR       | 200-400 ms    | f7f8 | 3-9 | mean amplitude, adaptive mean, peak latency, SME |
| MMN  | MMR       | 200-400 ms    | fcz  | 3-9 | mean amplitude, adaptive mean, peak latency, SME |
| MMN  | N1        | 40-79 ms      | t7t8 | 3-9 | mean amplitude, adaptive mean, peak latency, SME |
| MMN  | P1        | 80-100 ms     | t7t8 | 3-9 | mean amplitude, adaptive mean, peak latency, SME |
| MMN  | N2        | 100-180 ms    | t7t8 | 3-9 | mean amplitude, adaptive mean, peak latency, SME |
| FACE | N290      | 200-390 ms    | p8   | 3-6 | mean amplitude, SME                              |
| FACE | N290      | 200-390 ms    | p7   | 3-6 | mean amplitude, SME                              |
| FACE | P1        | 75-125 ms     | oz   | 3-6 | mean amplitude, SME                              |
| FACE | N290      | 400-600 ms    | oz   | 3-6 | mean amplitude, SME                              |
| FACE | P400      | 355-625 ms    | oz   | 3-6 | mean amplitude, SME                              |
| FACE | N290      | 200-340 ms    | p8   | 6-9 | mean amplitude, SME                              |
| FACE | N290      | 200-340 ms    | p7   | 6-9 | mean amplitude, SME                              |
| FACE | P1        | 75-125 ms     | oz   | 6-9 | mean amplitude, SME                              |
| FACE | N290      | 200-340 ms    | oz   | 6-9 | mean amplitude, SME                              |
| FACE | P400      | 350-600 ms    | oz   | 6-9 | mean amplitude, SME                              |
| FACE | Nc        | 300-650 ms    | FCz  | 3-9 | mean amplitude, SME                              |
| VEP  | N1        | 40-79 ms      | oz   | 3-6 | mean amplitude, adaptive mean, peak latency, SME |
| VEP  | P1        | 80-140 ms     | oz   | 3-6 | mean amplitude, adaptive mean, peak latency, SME |
| VEP  | N2        | 141-300 ms    | oz   | 3-6 | mean amplitude, adaptive mean, peak latency, SME |
| VEP  | N1        | 40-79 ms      | oz   | 6-9 | mean amplitude, adaptive mean, peak latency, SME |
| VEP  | P1        | 80-120 ms     | oz   | 6-9 | mean amplitude, adaptive mean, peak latency, SME |
| VEP  | N2        | 121-170 ms    | oz   | 6-9 | mean amplitude, adaptive mean, peak latency, SME |
| RS   | N/A       | 1000 ms epochs| all channels   | 3-9 | power |



## Output files (`.csv`)


For each task, two .csv files are automatically produced by MADE: a trial measures file and a summary statistics file.

Click :download:`here <csv_data_dictionary.csv>` to download a data dictionary defining the fields in each .csv output file. 

**I. Trial Measures**

Output files ending in ``trialMeasures.csv`` are created for MMN, VEP, and FACE and contain the following output variables for each trial retained after processing: 

MeanAmplitude
: Mean amplitude during specified measurement window

AvgPeak
: The average peak, or adaptive mean peak, is calculated by finding the peak during the specified time window and averaging the amplitude across all sampling points within 1 standard deviation of the peak. 

Latency
: Latency in ms to the peak amplitude during the specified time window


.. list-table:: FACE Trial Measures Output
   :widths: 31 50
   :header-rows: 1

   * - Variable Name
     - Description
   * - Condition
     - inverted, object, uprightInv, uprightObj
   * - TrialNum
     - trial
   * - MeanAmplitude_200-300_p8
     - Mean amplitude between 200-300 ms at P8 cluster.
   * - MeanAmplitude_75-125_oz
     - Mean amplitude between 75-125 ms at Oz cluster.
   * - MeanAmplitude_200-300_oz
     - Mean amplitude between 200-300 ms at Oz cluster.
   * - MeanAmplitude_325-625_oz
     - Mean amplitude between 325-625 OZ. 

.. list-table:: MMN Trial Measures Output
   :widths: 31 50
   :header-rows: 1

   * - Variable Name
     - Description
   * - Condition
     - standard, deviant, predeviant
   * - TrialNum
     - trial
   * - MeanAmplitude_200-400_t7t8
     - Mean amplitude between 200-400 ms at T7/T8 cluster.
   * - MeanAmplitude_200-400_f7f8
     - Mean amplitude between 200-400 ms at F7/F8 cluster.
   * - MeanAmplitude_200-400_fcz
     - Mean amplitude between 200-400 ms at FCz cluster.


**II. Summary Statistics**
	
Output files ending in ``summaryStats.csv`` are created for each task and contain the following output variables: 

	* ``SME``: Standard Measurement error. The SME is a universal measure of data quality for ERP data. See [Luck2021]_ for more information.

	* ``Mean_Power``: mean power at each frequency bin ranging from 1-50Hz

.. list-table:: FACE Summary Statistics Output
   :widths: 31 50
   :header-rows: 1

   * - Variable Name
     - Description
   * - Condition
     - inverted, object, uprightInv, uprightObj
   * - NTrials
     - number of trials retained per condition
   * - SME_200-300_p8
     - SME during 200-300 ms at P8 cluster
   * - SME_75-125_oz
     - SME during 75-125 ms at Oz cluster
   * - SME_200-300_oz
     - SME during 200-300 ms at Oz cluster
   * - SME_325-625_oz
     - SME during 325-625 ms at Oz cluster

.. list-table:: VEP Summary Statistics Output
   :widths: 31 50
   :header-rows: 1

   * - Variable Name
     - Description
   * - Condition
     - VEP
   * - NTrials
     - number of trials retained
   * - SME_40-79_oz
     - SME during 40-79 ms at Oz cluster
   * - SME_80-140_oz
     - SME during 80-140 ms at Oz cluster
   * - SME_141-300_oz
     - SME during 141-300 ms at Oz cluster

.. list-table:: MMN Summary Statistics Output
   :widths: 31 50
   :header-rows: 1

   * - Variable Name
     - Description
   * - Condition
     - deviant, predeviant, standard
   * - NTrials
     - number of trials retained per condition
   * - SME_200-400_t7t8
     - SME during 200-400 ms at T7/T8 cluster
   * - SME_200-400_f7f8
     - SME during 200-400 ms at F7/F8 cluster
   * - SME_200-400_fcz
     - SME during 200-400 ms at FCz cluster

.. list-table:: RS Summary Statistics Output
   :widths: 31 50
   :header-rows: 1

   * - Variable Name
     - Description
   * - Frequency
     - 1 Hz bins from 1-50 Hz
   * - SME
     - SME in each frequency bin
   * - Mean_Power
     - Mean power in each frequency bin
   * - ID
     - subject ID

