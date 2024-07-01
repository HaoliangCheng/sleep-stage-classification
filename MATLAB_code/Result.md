# Sleep Stage Classification using EEG Data

## Introduction
This project explores the use of machine learning techniques to classify sleep stages using EEG data. By leveraging the power of multiple models, we aim to improve the accuracy of sleep stage classification.

## EEG Data Preprocessing and Analysis
The EEG data was filtered into four band powers: delta, alpha, beta, and theta waves. This preprocessing step transformed complex sequence data into easier point data for analysis. 

### Data Summary
#### Training Data: Sample data from 127 individuals
- Stage 0: 49,137 data point
- Stage 1: 15,878 data point
- Stage 2: 56,612 data point
- Stage 3: 11,870 data point
- Stage R(REM): 21,685 data point
- **Total**: 155,182 data point
  
#### Testing Data: Sample data from 25 individuals
- Stage 0: 20,531 data point
- Stage 1: 5,591 data point
- Stage 2: 12,021 data point
- Stage 3: 1,121 data point
- Stage 4(REM): 4,082 data point
- **Total**: 43,346 data point

## Results

### Single Model Results
- **Filter + KNN**: 59.66%
- **Filter + DA**: 53.3%
- **Filter + Decision Tree**: 59.5%

### Ensemble Learning Results
- **Filter + Random Forest** (number of trees=58, min leaf size=25): 60.13%
- **Filter + Multi-tree (train sub-model by sample data from one individual, then aggregated result of these model)**: 53.8%
- **Filter + Multi-DA (train sub-model by sample data from one individual, then aggregated result of these model)**: 54.8%

## Reminder

### Balancing Data
- **DA**: Needs balanced data
- **DT/KNN**: Does not require balanced data

### Precision
- **Stage 1**: The precision in stage 1 is much lower than other stages in all these models.




