# mlbmachinelearning

## Summary

### Section 1 - Predicting Teams with a winning record




#### Dimensionality Reduction - Step 1

The original dataset with 79 feature variables is reduced in size by removing features based on relevance, high correlation, and low variance.
After completion, the dataset is reduced to 44 feature variables. 

After reduction, the continuous target variable Win/Loss percentage is converted to binary for future classification machine learning. 
Teams with a winning percentage below .500 will be represented by 0, teams over .500 will be represented by 1.
The target variable is close to evenly balanced, with 48% of the data being in class 0 and 52% being in class 1. 
