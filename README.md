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
* 0 represents a winning percentage below .500

* 1 represents a winning percentage above .500

All feature variables are normalized using Min Max Normalization to scale the data.

In all feature selection procedures, feature selection is done by examining results on the training set only to avoid overfitting.
The train/test split and scoring is repeated 250 times for each algorithm in order to achieve more accurate results. 

#### Mutual Information Gain

Code can be viewed here: [Mutual Information Gain Feature Selection](CIND820_Feature_selection_(ANOVA_F_test).ipynb)

#### ANOVA f-test

Code can be viewed here: [ANOVA f-test Feature Selection](CIND820_Feature_selection_(info_gain).ipynb)

#### Random Forest

Code can be viewed here: [Random Forest Feature Selection](CIND820_Feature_selection_(Random_Forest).ipynb)


