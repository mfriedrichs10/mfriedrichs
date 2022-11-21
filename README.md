# mlbmachinelearning

## Table of Contents

### Dimensionality Reduction - Step 1

The original dataset with 79 feature variables is reduced in size by removing features based on relevance, high correlation, and low variance.
After completion, the dataset is reduced to 44 feature variables. 

After reduction, the continuous target variable Win/Loss percentage is converted to binary for future classification machine learning. 
Teams with a winning percentage below .500 will be represented by 0, teams over .500 will be represented by 1.
The target variable is close to evenly balanced, with 48% of the data being in class 0 and 52% being in class 1. 

Code can be viewed here: [Dimensionality Reduction - Step 1](CIND820_Dimensionality_Reduction.ipynb)

### Feature Selection

Feature selection is conducted using three feature selection algorithms - Mutual Information Gain, ANOVA F-test, and Random Forest.

Prior to running each algorithm, the feature variable (win/loss percentage) is converted into a binary class variable with values 0 and 1.
<br>
* 0 represents a winning percentage below .500

* 1 represents a winning percentage above .500

All feature variables are normalized using Min Max Normalization to scale the data.

In all feature selection procedures, feature selection is done by examining results on the training set only to avoid overfitting.<br>

The train/test split and scoring is repeated 250 times for each algorithm in order to achieve more accurate results.<br>

After all the feature variables have been scored, the variables (columns) in the original dataset are re-ordered by importance, resulting in three separate datasets - one for each selection algorithm.

#### - Mutual Information Gain

Code can be viewed here: [Mutual Information Gain Feature Selection](CIND820_Feature_selection_(ANOVA_F_test).ipynb)

#### - ANOVA f-test

Code can be viewed here: [ANOVA f-test Feature Selection](CIND820_Feature_selection_(info_gain).ipynb)

#### - Random Forest

Code can be viewed here: [Random Forest Feature Selection](CIND820_Feature_selection_(Random_Forest).ipynb)

### Dimensionality Reduction - Step 2

The three datasets from the previous section are evaluated to determine what effect the count of feature variables has on the accuracy of the machine learning models. <br>

A for-loop is created to evaluate the accuracy score of each learning algorithm as features are added to the dataset. <br>

- As an example, loop 1 will calculate the average accuracy achieved by the Logistic Regression model with only 1 feature (column). Loop 2 will calculate the average accuracy with 2 features (columns) selected. Loop 3 will calculate based on 3 columns. And so on until a total of 44 iterations are run, one for each feature variable. <br>

Using 10-fold cross validation, the accuracy scores for each iteration will be captured, and once complete, the average score for each iteration will be calculated and plotted to observe the results. 

In all three algorithms, model accuracy increases significantly as additional features are added, peaking after approximately 5-10 features. <br>

The Logistic Regression and Random Forest learning algorithms maintain this level of accuracy with relatively minor fluctuations until all 44 features have been processed. <br>

The accuracy scores for the K Nearest Neighbors algorithm however, begin to drop after approximately 20 features have been added in each of the three feature sets. <br>

Based on these results, there is no major observed benefit to keeping all 44 features, and in the case of the KNN algorithm, it is actually a detriment.<br>

Prior to running the machine learning algorithms in the modeling stage, each dataset will be reduced to the top 20 features determined by the feature selection algorithms.

Code can be viewed here: [Dimensionality Reduction - Step 2](Select_top_features_(WinningRecord).ipynb)

### Modeling 

The three datasets created during the feature selection process are uploaded. 
Each dataset contains a different ordering of the feature variables based on their significance.
The top 20 features will be selected from each dataset for machine learning, as established in step 2 of dimensionality reduction.

A stratified train-test split is performed on each dataset, with 80% of the data assigned to training set and 20% assigned to test set.
Parameter tuning for each machine learning algorithm is performed on the training set using 10-fold cross validation.
The average accuracy and standard deviation is evaluated for each parameter.

Once the ideal parameters have been identified, the training set is used to fit the model and predictions are then made on the test set.
A confusion matrix and classification reports are generated to display the results. 

Each machine learning algorithm is run three times - once on each set of features selected by the feature selection algorithms. 
The algorithm parameters are evaluated on each set of features, and adjusted accordingly to achieve the highest accuracy. 

#### Logistic Regression



