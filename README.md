# mlbmachinelearning

## Table of Contents

### Dimensionality Reduction

The original dataset with 79 feature variables is reduced in size by removing features based on relevance, high correlation, and low variance.
After completion, the dataset is reduced to 44 feature variables. 

Code can be viewed here: [Dimensionality Reduction](CIND820_Dimensionality_Reduction.ipynb)

### Feature Selection

Feature selection is conducted using three feature selection algorithms - Mutual Information Gain, ANOVA F-test, and Random Forest.

Prior to running each algorithm, the feature variable (win/loss percentage) is converted into a binary class variable with values 0 and 1.
<br>
- 0 represents a winning percentage below .500
<br>
- 1 represents a winning percentage above .500
<br>
All feature variables are normalized using Min Max Normalization to scale the data.

#### Mutual Information Gain

