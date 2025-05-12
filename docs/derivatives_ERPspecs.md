# Derivatives and ERP specifications

## Derivatives by task

`HBCD-EEG-Utilities.m` computes the following derivatives for each task

| Task | Derivatives     |
|------|----------------|
| FACE | SME, Mean amplitude            |
| MMN  | SME, Mean amplitude           |
| VEP  | SME, Mean amplitude, Adaptive mean, Peak latency            |
| RS   | SME, Absolute power, Log power, dB Power         |


- **Mean amplitude**: Mean amplitude during specified measurement window 

- **Adaptive mean**: Adaptive mean amplitude is calculated by finding the peak during the specified time window and averaging the amplitude across all sampling points within 1 standard deviation of the peak. 

- **Peak latency**: Latency in ms to the peak amplitude during the specified time window

- **SME**: Standard Measurement Error. The SME is a universal measure of data quality for ERP data. See [Luck2021]_ for more information.

- **Power**: mean power at each frequency bin ranging from 1-50Hz
 
## ERP specifications

ERP derivatives for the MMN, FACE, and VEP tasks contain the following components at the specified time windows and ROIs:

### MMN ERP Derivatives
| Task | Component | Time window | ROI  | Age |
|------|-----------|-------------|------|-----|
| MMN  | MMR       | 200-400 ms    | t7t8 | 3-9 |
| MMN  | MMR       | 200-400 ms    | f7f8 | 3-9 |
| MMN  | MMR       | 200-400 ms    | fcz  | 3-9 |

### FACE ERP Derivatives
| Task | Component | Time window | ROI  | Age |
|------|-----------|-------------|------|-----|
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

### VEP ERP Derivatives
| Task | Component | Time window | ROI  | Age |
|------|-----------|-------------|------|-----|
| VEP  | N1        | 40-79 ms      | oz   | 3-6 |
| VEP  | P1        | 80-140 ms     | oz   | 3-6 | 
| VEP  | N2        | 141-300 ms    | oz   | 3-6 |
| VEP  | N1        | 40-79 ms      | oz   | 6-9 |
| VEP  | P1        | 80-120 ms     | oz   | 6-9 |
| VEP  | N2        | 121-170 ms    | oz   | 6-9 |


### RS Power Derivatives
| Task | Derivative | Age |
|------|-----------|-------------|
| RS  | Absolute power in µV²/Hz | 3-9 |
| RS  | Natural log power         | 3-9 | 
| RS  | Power in decibels (db)     | 3-9 |

Power values are calculated as follows:

```{r}

Absolute Power = (μV²  / Hz)

Log Power μV²  = log10 (1 + Absolute Power)

Power (dB) = 10 × log10 (Power (μV² / Hz))

```

