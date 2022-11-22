# mlbmachinelearning

## Table of Contents

### Section 1 - Predicting Teams with a winning record

The first section of this project will be focused on finding the most effective ML model at predicting whether a Major League Baseball team has a winning record or not, based on average yearly statistics. A team has a winning record if their win/loss percentage is above .500 (50%). The dataset being used consists of 79 feature variables (statistics) and 1 target variable (W/L%) accounting for 50 years of team results and 1396 instances. 

The dataset can be downloaded [here](CIND 820 Dataset - MLB 1972-2021.xlsx)

#### Dimensionality Reduction - Step 1

The original dataset with 79 feature variables is reduced in size by removing features based on relevance, high correlation, and low variance.
After completion, the dataset is reduced to 44 feature variables. 

After reduction, the continuous target variable Win/Loss percentage is converted to binary for future classification machine learning. 
Teams with a winning percentage below .500 will be represented by 0, teams over .500 will be represented by 1.
The target variable is close to evenly balanced, with 48% of the data being in class 0 and 52% being in class 1. 

Code can be viewed here: [Dimensionality Reduction - Step 1](Dimensionality_Reduction.ipynb)

#### Feature Selection

Feature selection is conducted using three feature selection algorithms - Mutual Information Gain, ANOVA F-test, and Random Forest.

Prior to running each algorithm, the feature variable (win/loss percentage) is converted into a binary class variable with values 0 and 1.
<br>
* 0 represents a winning percentage below .500

* 1 represents a winning percentage above .500

All feature variables are normalized using Min Max Normalization to scale the data.

In all feature selection procedures, feature selection is done by examining results on the training set only to avoid overfitting.<br>

The train/test split and scoring is repeated 250 times for each algorithm in order to achieve more accurate results.<br>

After all the feature variables have been scored, the variables (columns) in the original dataset are re-ordered by importance, resulting in three separate datasets - one for each selection algorithm.

##### - Mutual Information Gain

Code can be viewed here: [Mutual Information Gain Feature Selection](CIND820_Feature_selection_(info_gain).ipynb)

##### - ANOVA f-test

Code can be viewed here: [ANOVA f-test Feature Selection](CIND820_Feature_selection_(ANOVA_F_test).ipynb)

##### - Random Forest

Code can be viewed here: [Random Forest Feature Selection](CIND820_Feature_selection_(Random_Forest).ipynb)

#### Dimensionality Reduction - Step 2

The three datasets from the previous section are evaluated to determine what effect the count of feature variables has on the accuracy of the machine learning models. <br>

A for-loop is created to evaluate the accuracy score of each learning algorithm as features are added to the dataset. <br>

- As an example, loop 1 will calculate the average accuracy achieved by the machine learning model with only 1 feature (column). Loop 2 will calculate the average accuracy with 2 features (columns) selected. Loop 3 will calculate based on 3 columns. And so on until a total of 44 iterations are run, one for each feature variable. <br>

Using 10-fold cross validation, the accuracy scores for each iteration will be captured, and once complete, the average score for each iteration will be calculated and plotted to observe the results. 

In all three algorithms, model accuracy increases significantly as additional features are added, peaking after approximately 5-10 features. <br>

The Logistic Regression and Random Forest learning algorithms maintain this level of accuracy with relatively minor fluctuations until all 44 features have been processed. <br>

The accuracy scores for the K Nearest Neighbors algorithm however, begin to drop after approximately 20 features have been added in each of the three feature sets. <br>

Based on these results, there is no major observed benefit to keeping all 44 features, and in the case of the KNN algorithm, it is actually a detriment.<br>

Prior to running the machine learning algorithms in the modeling stage, each dataset will be reduced to the top 20 features determined by the feature selection algorithms.

Code can be viewed here: [Dimensionality Reduction - Step 2](Select_top_features_(WinningRecord).ipynb)

#### Modeling 

The three datasets created during the feature selection process are uploaded. 
Each dataset contains a different ordering of the feature variables based on their significance.
The top 20 features will be selected from each dataset for machine learning, as established in step 2 of dimensionality reduction.

A stratified train-test split is performed on each dataset, with 80% of the data assigned to training set and 20% assigned to test set.
Parameter tuning for each machine learning algorithm is performed on the training set using 10-fold cross validation.
The average accuracy and standard deviation is evaluated for each parameter.
Accuracy is being considered the primary evaluation metric given that the target classes are nearly balanced, and not one class is prefered over the other.

Once the ideal parameters have been identified, the training set is used to fit the model and predictions are then made on the test set.
A confusion matrix and classification reports are generated to display the results. 

Each machine learning algorithm is run three times - once on each set of features selected by the feature selection algorithms. 
The algorithm parameters are evaluated on each set of features, and adjusted accordingly to achieve the highest accuracy. 

##### - Logistic Regression

Code can be viewed here: [Logistic Regression](CIND820_Logistic_Regression_(WinningRecord).ipynb)

##### - K Nearest Neighbors

Code can be viewed here: [K Nearest Neighbors](CIND820_K_Nearest_Neighbors_(WinningRecord).ipynb)

##### - Random Forest

Code can be viewed here: [Random Forest](CIND820_Random_Forest_(WinningRecord).ipynb)

### Section 2 - Predicting Teams that will make the playoffs

This section of the project is focused on finding the most effective ML model at predicting whether a Major League Baseball team has a winning percentage of .550 and above. This percentage is widely considered to be the "magic number" to qualify for the playoffs. The machine learning process will be very similar to the one followed in Section 1, however this time the target class is highly imbalanced. 

Winning percentages below .550, represented by 0, account for 74% of the data while the remaining 24% is teams over .550. Accuracy will not be an effective evaluation metric for this highly imbalanced dataset, so the F1 score will be considered. The performance of the machine learning algorithms from the previous section will be evaluated on this new dataset, and results will be compared with those from the previous balanced dataset. Different sampling techniques will be assessed to see if they can improve model performance. 

** The files listed below follow the same process as described in Section 1, however performance is now based on the F1 score instead of accuracy. 

#### Feature Selection

##### - Mutual Information Gain

Code can be viewed here: [Mutual Information Gain Feature Selection](Feature_selection_(info_gain)_Playoffs.ipynb)

##### - ANOVA f-test

Code can be viewed here: [ANOVA f-test Feature Selection](Feature_selection_(ANOVA_F_test)_Playoffs.ipynb)

##### - Random Forest

Code can be viewed here: [Random Forest Feature Selection](Feature_selection_(Random_Forest)_Playoffs.ipynb)


#### Dimensionality Reduction - Step 2

Code can be viewed here: [Dimensionality Reduction - Step 2](Select_top_features_(Playoffs).ipynb)


#### Modeling 

##### - Logistic Regression

Code can be viewed here: [Logistic Regression](CIND820_Logistic_Regression_(Playoffs).ipynb)

##### - K Nearest Neighbors

Code can be viewed here: [K Nearest Neighbors](CIND820_K_Nearest_Neighbors_(Playoffs).ipynb)

##### - Random Forest

Code can be viewed here: [Random Forest](CIND820_Random_Forest_(Playoffs).ipynb)
