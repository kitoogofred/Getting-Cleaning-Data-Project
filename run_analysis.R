## Kitoogo Fredrick
## Project for the Getting and Cleaning Data Project
## Purpose: to demonstrate the ability to collect, work with, and clean a data set.
## Goal: to prepare tidy data that can be used for later analysis. 
## Dataset: accelerometers from the Samsung Galaxy S smartphone
##  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## ______________________________________________________________________
## Functionality of the script
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set
##    with the average of each variable for each activity and each subject.

## ----- Loading requisite packages -----------
library("dplyr", lib.loc="\\\\Rsv-nita-01/USER$/Fredrick.Kitoogo/R/win-library/3.2")

## Load the RCurl Package for ease of reading from https
library("RCurl", lib.loc="\\\\Rsv-nita-01/USER$/Fredrick.Kitoogo/R/win-library/3.2")

## Set the Working Directory
setwd("//rsv-nita-01/USER$/Fredrick.Kitoogo/NITA/New/Personal/Training/Data Science/John Hopkins/Course 3/Project")

## _____________________________________________________________________________________________

## Part 1
## Merge the training and the test sets to create one data set.
## _____________________________________________________________________________________________

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

download_data()
merged_all <- merge_data()

## ____________________________________________________________________________________________________
## Part 2
## Extracts only the measurements on the mean and standard deviation for each measurement.
## ____________________________________________________________________________________________________
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

## ____________________________________________________________________________________________________  
  
## ____________________________________________________________________________________________________
## Part 3
##  Uses descriptive activity names to name the activities in the data set
## ____________________________________________________________________________________________________
## Already done in Part 1 above
## Display the names
grep("activity", tolower(colnames(mean_std_Data)), value = TRUE)
## ____________________________________________________________________________________________________  

## ____________________________________________________________________________________________________
## Part 4
## Appropriately label the data frame with descriptive variable names
## The following Acronyms are replaced according to the convention below
##  t is replaced with time
##  Acc is replaced with Accelerometer
##  Gyro is replaced with Gyroscope
##  f is replaced with frequency
##  Mag is replaced with Magnitude
##  BodyBody is replaced with Body
## ____________________________________________________________________________________________________
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

## ____________________________________________________________________________________________________  
## ____________________________________________________________________________________________________
## Part 5
##  From the data set in step 4, creates a second, independent tidy data set
##  with the average of each variable for each activity and each subject.
## ____________________________________________________________________________________________________

## Using the dplyr package to summarize the data grouped by subjectID and activityID
## Also include the activityName to avoid error when summarizing information related to the column
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

## ____________________________________________________________________________________________________  




