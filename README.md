# Getting-and-Cleaning-Data-Course-Project
##Project objectives:
(Quoted from the course page)
Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##How does the code work:
I will focus on the major points here since the code does what is stated above.

###Objective number 2
Firstly I used grepl to identify features that are either a mean or a standard deviation. For example -
```
features<-mutate(features,std_ = grepl('std()',feature))
features<-mutate(features,mean_ = grepl('mean()',feature))
features_to_use <- filter(features,std_==TRUE | mean_==TRUE )
```
Then I used dplyr select() function to select the coloumns I need -

```
data_all <-select(data_all,subject,activity,one_of(features_to_use$labels_to_use))
```

###Objective number 3
This was simply done using the dplyr merge function using the main data frame I am creating and the 'activity_labels.txt' data.

###Objective number 5
This is all dplyr.
We first group by -
```
activity_subject_df <- group_by(data_all,activity,subject)
```
Then we need to create a mean for each coloumn and summarise_each helps here instead of summarise
```
data_averaged<-summarise_each(activity_subject_df,funs(mean))
```
