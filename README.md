# mlbmachinelearning

## Table of Contents

### Dimensionality Reduction - Step 1

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
After all the feature variables have been scored, the variables (columns) in the original dataset are re-ordered by importance, resulting in three separate datasets - one for each selection algorithm.

<u>#### Mutual Information Gain</u>

Code can be viewed here: [Mutual Information Gain Feature Selection](CIND820_Feature_selection_(ANOVA_F_test).ipynb)

#### * ANOVA f-test

Code can be viewed here: [ANOVA f-test Feature Selection](CIND820_Feature_selection_(info_gain).ipynb)

#### * Random Forest

Code can be viewed here: [Random Forest Feature Selection](CIND820_Feature_selection_(Random_Forest).ipynb)

### Dimensionality Reduction - Step 2

The three datasets from the previous section are used to 

A for-loop is created to evaluate the accuracy score of each learning algorithm as features are added to the dataset. <br>
A total of 44 iterations will be run, one for each feature variable. <br>
Using 10-fold cross validation, the accuracy scores for each iteration will be captured, and once complete, the average score for each iteration will be calculated and plotted to observe the results. 

In all three algorithms, model accuracy increases significantly as additional features are added, peaking after approximately 5-10 features. <br>
The Logistic Regression and Random Forest learning algorithms maintain this level of accuracy with relatively minor fluctuations until all 44 features have been processed. <br>
The accuracy scores for the K Nearest Neighbour algorithm however, begin to drop after approximately 20 features have been added in each of the three feature sets. <br>
Based on these results, each dataset will be reduced to the top 20 features, and all future machine learning will be conducted with this data. 
