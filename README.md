# Sleep Stage Classification Preparation

## Overview
This project is used in Dr. Mao's sleep stage classification lab which involves downloading and preparing sleep stage data for classification. The steps include downloading sample data, reading EDF files, preparing the data by removing unnecessary stages, and applying dimensional reduction techniques (filter). Then，we can use the preprocessed data to train the model.

## Outline
1. [Download Sample Data](#download-sample-data)
2. [Read EDF File](#read-edf-file) + [Prepare Data](#prepare-data)
3. [Dimensional Reduction](#dimensional-reduction)

## Download Sample Data
To download the sample data, run the `download_database.py` script which will download the EDF files to this directory where XXX-PSG file stores the signal information and XXX-Hypnogram file with the same number stores the corresponding sleep stage information. You would better divide the total 152 samples into two parts (ex. 122 training samples and 30 testing samples) to process these data separately.

### Data Link
- [PhysioNet Sleep-EDF Database](https://www.physionet.org/files/sleep-edfx/1.0.0/)

### Script for Data Download
- [download_database.py](https://github.com/HaoliangCheng/sleep-stage-classification/blob/main/download_database.py)

## Read EDF File + Prepare Data
The data preparation involves cleaning the downloaded data:
- Remove most parts of wake stages, all movements, and unknown stages.
- Keep only stages 0, 1, 2, 3, 4.

### Python
For Python code, you can directly run the code for data processing. 

### MATLAB
For MATLAB code, you need to put your downloaded data into sleep_stage_training_data and sleep_stage_testing_data dir, then you can run the code for data processing.

### Scripts for Data Preparation
- [MATLAB Script: prepare_sleepedf.m](https://www.dropbox.com/scl/fi/5ogwjlnjs3ohareqfqimq/prepare_sleepedf.m?rlkey=6ombtyv3wj3a0qbft9baj1foy&dl=0)
- [Python Script: prepare_sleepedf.py](https://github.com/HaoliangCheng/sleep-stage-classification/blob/main/prepare_sleepedf.py)

## Dimensional Reduction
To reduce the dimensionality of the data, brainwave signals are filtered and the energy of these signals is estimated.

### Brainwave Signals
- Delta signal: 1Hz – 4Hz
- Theta signal: 4Hz – 8Hz
- Alpha signal: 8Hz – 12Hz
- Beta signal: 12Hz – 30Hz

### Filtering
A Butterworth bandpass filter is applied to the brainwave signals.

### Energy Estimation
The energy of the filtered signals is estimated by summing the squares of the signals.

### Results
The resulting signals after filtering and energy estimation are:
- Delta wave
- Theta wave
- Alpha wave
- Beta wave
These four types of signal wave energy are input data in model training and the sleep stages are output in model training.

## Author
Haoliang Cheng (The Python code is formed based on tinysleepnet[https://github.com/akaraspt/tinysleepnet])
