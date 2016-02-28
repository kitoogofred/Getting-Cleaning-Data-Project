---
title: "Getting and Cleaning Data Project README.md"
output:
  html_document:
    toc: true
    theme: united
author: Kitoogo Fredrick
---
## Overview
This project serves to demonstrate the ability to collect, work with, and clean a data set that can subsequently be used for future analysis. The different elements of the project and how they are interconnected is detailed below.

## The Data Set
The data is sourced from the accelerometers from the Samsung Galaxy S smartphone. A full description of the data source can be obtained from: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The specific data set for this project can be found at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Project Summary
In summary, to demonstrate the objectives of the project, create an R script called run_analysis.R that downloads and reads data into R objects and does the following:

1. Merges the training and the test sets to create one data set;
2. Extracts only the measurements on the mean and standard deviation for each measurement;
3. Uses descriptive activity names to name the activities in the data set; 
4. Appropriately labels the data set with descriptive activity names; 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Files in the Repository
The repo includes the following files: 

1. README.md : This gives an overview of the project, details how all of the scripts work and how they are connected.
2. run_analysis.R : This is the script with the R Code that is used to perform the analysis on the data
3. CodeBook.md: This describes the variables, the data, and any transformations or work that was performed to clean up the data
4. tidy_aggr_Data.txt: This contains the tidy which is an output from the analysis. This is saved in a Text file 

## Functionality of the run_analyis.R Script

1.	Downloads the dataset from the URL mentioned above and unzips it to create UCI HAR Dataset folder
2.	Reads the metadata (Activity Labels and Features data files) into data frames and assigns descriptive column names for the activity_labels and features data frames
3.	Imports test and train datasets and creates data frames from them and assign column names from the features Data Frame
4.	Read the other training related data (from y_train.txt).  Assign the columns descriptive names and merge the Labels with the Activity Labels Data Frame to ensure the actual Activity names are assigned
5.	Read the Test related data (from y_test.txt). Assign the columns descriptive names and merge the Labels with the Activity Labels Data Frame to ensure the actual Activity names are assigned
6.	Read the Subjects Information (from subject_train.txt and subject_test.txt) and assign them descriptive names
7.	Merge the Training Subject (from 6 above), Training Activity (from 4 above) and the corresponding Training Data (from 3 above) column-wise using cbind to create a proper Test Data Frame with Subject and Training Activity Information and name the Data Frame merged_training
8.	Merge the Test Subject (from 6 above), Test Activity (from 5 above) and the corresponding Test Data (from 3 above) column-wise using cbind to create a proper Test Data Frame with Subject and Test Activity Information and name the Data Frame merged_test
9.	Merges the Training and the Test Data Frames (from 7 and 8 above) to create one Data Frame named merged_all
10.	Extracts a subset of data with only the measurements on the mean mean() and standard deviation std() for each measurement. Also excludes meanFreq()-X measurements or angle measurements where the term mean exists resulting in 66 measurement variables.
11.	Appropriately updates the variable names in dataframe variable names for data fame to improve readability
12.	Reshapes dataset to create a data frame with average of each measurement variable for each activity and each subject
13.	Writes new tidy data frame to a text file to create the required tidy data set file of 40 observations and 69 columns (3 columns for subjectID, activityID, activityName and 66 columns for measurement variables). Note that it is not necessarily true that the observations have to be 180 (i.e. number of subjects (30) * number of Activity Types (6)) because it is noticed that not all subjects observed the entire range of the 6 activity types.





