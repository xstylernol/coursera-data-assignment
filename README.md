script: run_analysis.R

Libraries: dplyr, reshape2

Imports train and test data sets
================================
X: results
y: IDs corresponding to the activities
subject: IDs corresponding to the test subjects

Supporting data sets
====================
features: the feature names corresponding to the columns of X
activity_labels: maps the activity IDs to activity descriptions

Q1
For each of the test and train sets, binds the columns together so that the activity and subject IDs are attached to the data in X. Then appends the train to the test data to form the "alldata" dataset.

Q2
Use grepl function to find all feature column indices that have either "mean...()" or "std...()" in the feature name. Subsets the valid columns from "alldata" into "stdmeandata"

Q3
Merge the activity name labels into the "alldata" table by Activity ID

Q4
Renames the variables in "alldata" by order of feature names

Q5
- Melt the "alldata" dataset into 4 columns: activity, subject, variable, and value
- Convert the subjectID from character into factor
- Convert the features/variables from factor into character. This is because several of the variable names are duplicated. Since these duplicates are stored as factors, we need to convert into character type so that finding the "mean" will combine all the variables that have the same name.
- Use the summarize function from dplyr to average the data by activity, subject, and true variable name

Notes on Q5
This data is now tidy because
1) Each variable in its own column: based on the structure of the question, the variables = subject, activity, feature name, and mean value
2) Each observation forms its own row: each combination of activity, subject, and feature has its own row
3) The one table stores data from the activity tracker