# Sleep Stage Classification Preparation

## Overview
This project is used in Dr. Mao's sleep stage classification lab which involves downloading and preparing sleep stage data for classification. The steps include downloading sample data, reading EDF files, preparing the data by removing unnecessary stages, and applying dimensional reduction techniques (filter). Then，we can use the preprocessed data to train the model.

## Outline
1. [Download Sample Data](#download-sample-data)
2. [Read EDF File](#read-edf-file)
3. [Prepare Data](#prepare-data)
4. [Dimensional Reduction](#dimensional-reduction)

## Download Sample Data
To download the sample data, run the `download_database.py` script which will download the EDF files to your computer.

### Data Link
- [PhysioNet Sleep-EDF Database](https://www.physionet.org/files/sleep-edfx/1.0.0/)

### Script for Data Download
- [download_database.py][(https://github.com/HaoliangCheng/sleep-stage-classification/blob/main/download_database.py)]

## Read EDF File
Import the downloaded EDF file into MATLAB/Python for data processing.

## Prepare Data
The data preparation involves cleaning the downloaded data:
- Remove most parts of wake stages, all movements, and unknown stages.
- Keep only stages 0, 1, 2, 3, 4.

### Scripts for Data Preparation
- [MATLAB Script: prepare_sleepedf.m](https://www.dropbox.com/scl/fi/5ogwjlnjs3ohareqfqimq/prepare_sleepedf.m?rlkey=6ombtyv3wj3a0qbft9baj1foy&dl=0)
- [Python Script: prepare_sleepedf.py](https://www.dropbox.com/scl/fi/9lafkzchafikakr1mvv9a/prepare_sleepedf.py?rlkey=h2tcqen4rk3uteobtrh3qgtgx&dl=0)

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
Haoliang Cheng
