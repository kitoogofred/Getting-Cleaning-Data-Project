---
title: "Getting and Cleaning Data Project CodeBook.md"
output:
  html_document:
    toc: true
    theme: united
author: Kitoogo Fredrick
---
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
One of the most exciting areas in all of data science right now is wearable computing. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained from: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The specific data set for this project can be found at: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Project Summary

In summary, to demonstrate the objectives of the project, create an R script called run_analysis.R that downloads and reads data into R objects and does the following:

1.	Merges the training and the test sets to create one data set;
2.	Extracts only the measurements on the mean and standard deviation for each measurement;
3.	Uses descriptive activity names to name the activities in the data set; 
4.	Appropriately labels the data set with descriptive activity names; 
5.	Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Description of the Data

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. and the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) - both using a low pass Butterworth filter.
The body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

A Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

### Description of abbreviations of measurements

1.	leading t or f is based on time or frequency measurements.
2.	Body = related to body movement.
3.	Gravity = acceleration of gravity
4.	Acc = accelerometer measurement
5.	Gyro = gyroscopic measurements
6.	Jerk = sudden movement acceleration
7.	Mag = magnitude of movement
8.	mean and SD are calculated for each subject for each activity for each mean and SD measurements.

The units given are g's for the accelerometer and rad/sec for the gyro and g/sec and rad/sec/sec for the corresponding jerks.
These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions. They total 33 measurements including the 3 dimensions - the X,Y, and Z axes.

*	tBodyAcc-XYZ
*	tGravityAcc-XYZ
*	tBodyAccJerk-XYZ
*	tBodyGyro-XYZ
*	tBodyGyroJerk-XYZ
*	tBodyAccMag
*	tGravityAccMag
*	tBodyAccJerkMag
*	tBodyGyroMag
*	tBodyGyroJerkMag
*	fBodyAcc-XYZ
*	fBodyAccJerk-XYZ
*	fBodyGyro-XYZ
*	fBodyAccMag
*	fBodyAccJerkMag
.	fBodyGyroMag
.	fBodyGyroJerkMag

### The set of variables that were estimated from these signals are:

*	mean(): Mean value
*	std(): Standard deviation

## Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Load the Packages

```R
## ----- Loading requisite packages -----------
library("dplyr", lib.loc="\\\\Rsv-nita-01/USER$/Fredrick.Kitoogo/R/win-library/3.2")

## Load the RCurl Package for ease of reading from https
library("RCurl", lib.loc="\\\\Rsv-nita-01/USER$/Fredrick.Kitoogo/R/win-library/3.2")

```

## Set the Working Directory

```R
## Set the Working Directory
setwd("//rsv-nita-01/USER$/Fredrick.Kitoogo/NITA/New/Personal/Training/Data Science/John Hopkins/Course 3/Project")

```

## Download and Unzip the Data
```R
## Function for reading and unzipping files
download_data <- function() {
  
  ## Check for and create data folder
  if(!file.exists("./data")){
    message("Creating data directory")
    dir.create("./data")}
  
  ## Assign the fileURL to an R Object
  fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  
  ## Download the zipped file 
  destfile="./data/UCI_HAR_Dataset.zip"
  message("Downloading data.........")
  download.file(fileUrl,destfile=destfile, method="libcurl")
  
  ## Unzip the file into the data Folder
  message("Unzipping.........")
  unzip(destfile, files = NULL, list = FALSE, overwrite = TRUE,
        junkpaths = FALSE, exdir = "./data", unzip = "internal",
        setTimes = FALSE)  
}
download_data() ## call the function to download and unzip the Data

```

## Files in folder 'UCI HAR Dataset' that will be used are:

### Meta Data Files
* activity_labels.txt - Links the activity class labels with the activity name
* features.txt -Names of column variables in the Data Files

### Data Files
* X_train.txt - Training Data Set
* X_test.txt - Test Data Set

### Activity Files
* y_train.txt - Training Data Activity Labels
* y_train.txt - Test Data Activity Labels

## 1.	Read the Data, Create Data Frames and Merge the Data 

```R
merge_data <- function() {
  
  # Read the metadata (Activity Labels and Features) into data frames
  activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)
  features <-  read.table("./data/UCI HAR Dataset/features.txt")
  ## Assign descriptive column names for the activity_labels and features dataframes
  colnames(features) <- c("featurenID","featureName")
  colnames(activity_labels) <- c("activityID","activityName")
  
  
  ## Read Training and Te=st Data and assign column names from the features Data Frame
  X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
  colnames(X_train) <- features$featureName
  X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
  colnames(X_test) <- features$featureName
  
  
  ## Read the Training related data
  ## Assign the columns descriptive names
  ## Merge the Labels with the Activity Lables Data Frame to ensure the actual Activity names are
  ## Assigned
  training_Labels<- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
  colnames(training_Labels) <- c("activityID")
  training_Activity <- merge(training_Labels, activity_labels)
  
  ## Read the Test related data
  ## Assign the columns descriptive names
  ## Merge the Labels with the Activity Lables Data Frame to ensure the actual Activity names are
  ## Assigned
  test_Labels <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
  colnames(test_Labels) <- c("activityID")
  test_Activity <- merge(test_Labels, activity_labels)

  
  ## Read the Subjects
  ## Assign them descriptive names
  subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
  colnames(subject_train) <- c("subjectID")
  subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
  colnames(subject_test) <- c("subjectID")
  
  
  ## Merge the Training Subject, Training Activity and the corresponding Training Data columnwise
  ## Use cbind
  merged_training <- cbind(subject_train, training_Activity, X_train)
  
  
  ## Merge the Test Subject, Test Activity and the corresponding Test Data columnwise
  ## Use cbind
  merged_test <- cbind(subject_test, test_Activity, X_test) 
  
  
  ## Merge the Training Data and the Test Data by Rows
  ## Use rbind
  merged_all <- rbind(merged_training, merged_test)
  
}

merged_all <- merge_data() ## Call the function to read and merge the data

```

## 2.	Extract only the measurements on the mean and standard deviation for each measurement.

```R
## Assign the required columns(subjectID, activityName and those of mean and std)
activity_subject_Features <- c("subjectID", "activityID", "activityName")

## Assign the required columns related to mean and std)
## Option 1 - with just mean and std
mean_std_features_old <- grep("mean()|std()",colnames(merged_all), value = TRUE)
## Option 2 - those strickly ending with mean or strickly std
mean_std_features <- grep("mean\\(\\)|std\\(\\)", colnames(merged_all), value = TRUE) 
## Check to the differnce between the two options to enable the right choice
setdiff(mean_std_features_old, mean_std_features)

## Concatenate the two vectors to get the vector of all required columns using option 2
required_features <- c(activity_subject_Features, mean_std_features)
## Subset from the merged_all object only the required 
## columns (subjectID, activityID, activityName and those of mean and std)
mean_std_Data <- subset(merged_all,select=required_features)


```

## 3.	Uses descriptive activity names to name the activities in the data set.

```R
## Already done in Part 1 above
## Display the names
grep("activity", tolower(colnames(mean_std_Data)), value = TRUE)

```

## 4.	Appropriately label the data set with descriptive activity names..

The following Acronyms are replaced according to the convention below

* t is replaced with time
*	Acc is replaced with Accelerometer
*	Gyro is replaced with Gyroscope
*	f is replaced with frequency
*	Mag is replaced with Magnitude
*	BodyBody is replaced with Body

```R
colnames(mean_std_Data)<-gsub("^t", "time", colnames(mean_std_Data))
colnames(mean_std_Data)<-gsub("^f", "frequency", colnames(mean_std_Data))
colnames(mean_std_Data)<-gsub("Acc", "Accelerometer", colnames(mean_std_Data))
colnames(mean_std_Data)<-gsub("Gyro", "Gyroscope", colnames(mean_std_Data))
colnames(mean_std_Data)<-gsub("Mag", "Magnitude", colnames(mean_std_Data))
colnames(mean_std_Data)<-gsub("BodyBody", "Body", colnames(mean_std_Data))

## Print the Column Names
colnames(mean_std_Data)

## Save into a csv called mean_std_Data.csv 
## This is for verifying the view of the data before finally saving it into a text file
write.csv(mean_std_Data,"./data/tidy_mean_std_Data.txt", row.names = FALSE) 

## Save into a Text called mean_std_Data.txt
write.table(mean_std_Data,"./data/tidy_mean_std_Data.txt",sep=" ", row.names = FALSE)

```
## 5.	Extract only the measurements on the mean and standard deviation for each measurement.

```R
## Using the dplyr package to summarize the data grouped by subjectID and activityID
## Also include the activityName to avoid error when summarizing information related to the colum

tidy_aggr_Data <- mean_std_Data %>% 
  group_by(subjectID, activityID, activityName) %>% 
  summarize_each(funs(mean))

## It is noted that new variables (columns) related to measurments 
## are Averages of the original variables. 
## They are thus named accordingly to append [Average of] at the begining of the variable name
## but not renamng the first three variables
colnames(tidy_aggr_Data)[-c(1:3)] <- paste("[Average of]" , colnames(tidy_aggr_Data)[-c(1:3)])

## save into a Text File called tidy_aggr_Data.csv
## This is for verifying the view of the data before finally saving it into a text file
write.csv(tidy_aggr_Data, "./data/tidy_aggr_Data.csv", row.names = FALSE)

## save into a Text File called tidy_aggr_Data.txt
write.table(tidy_aggr_Data,"./data/tidy_aggr_Data.txt",sep=" ", row.names = FALSE)

```
The tidy data set a set of variables for each activity and each subject. 10299 instances are split into 40 resultant groups (Note that it is not necessarily true that the observations have to be 180 (i.e. number of subjects (30) * number of Activity Types (6)) because it is noticed that not all subjects observed the entire range of the 6 activity types) and 66 mean and standard deviation features are averaged for each group. The resulting data table has 180 rows and 69 columns - 33 Mean variables + 33 Standard deviation variables + 1 subjectID (1 of of the 30 test subjects) + activityID+ activityName . The tidy data set's first row is the header containing the names for each column. The 66 Variables ate averages when grouped by the subjectID and activityID.



