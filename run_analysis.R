# Lets load all the data into R first
# Since the folder structure is same we can probably write one script to load both
# test and train data
library(dplyr)
#load the general data
setwd("./UCI HAR Dataset")

features <- read.table("features.txt",sep='',col.names = c('label','feature'),stringsAsFactors = FALSE)
# we generate a new coloumn to identify the feature variables
features<-mutate(features,labels_to_use = paste('f_',label,sep=''))
#also we identify the features which are a mean or an std
features<-mutate(features,std_ = grepl('std()',feature))
features<-mutate(features,mean_ = grepl('mean()',feature))
features_to_use <- filter(features,std_==TRUE | mean_==TRUE )

activity_labels <- read.table("activity_labels.txt",sep='',col.names = c('label','activity'))


#load test data
filepath <- 'test'
setwd(paste("./",filepath,sep=''))

#load the test data and combine into one dataframe
y <- read.table(paste('y_',filepath,'.txt',sep=''),sep='')
x <- read.table(paste('x_',filepath,'.txt',sep=''),sep='')
subject <- read.table(paste('subject_',filepath,'.txt',sep=''))
test_data <-cbind(subject,y,x)

#remove some dataframes 
rm(x,y,subject)

#load train data
filepath <- 'train'
setwd("..")
setwd(paste("./",filepath,sep=''))

#load the test data
y <- read.table(paste('y_',filepath,'.txt',sep=''))
x <- read.table(paste('x_',filepath,'.txt',sep=''))
subject <- read.table(paste('subject_',filepath,'.txt',sep=''))
train_data <-cbind(subject,y,x)

#remove some dataframes 
rm(x,y,subject)

#combine test and train data
data_all <- rbind(test_data,train_data)

#remove test and train data frames
rm(test_data,train_data)


#now we name the coloumns of the data frame
# the first coloumn is subject, then its the activity label and then the 561 features
col_names <- c('subject','activity_label',as.vector(features$labels_to_use))
colnames(data_all)<-col_names


#we now add the activities as a new coloumn
#we will use the dply library merge function
data_all<-merge(activity_labels,data_all,by.x='label',by.y='activity_label',all = TRUE)


#however we only need the features_to_use features
#use the select command from dply

data_all <-select(data_all,subject,activity,one_of(features_to_use$labels_to_use))



#average of each variable for each activity
#we use dplyr groupby here

activity_subject_df <- group_by(data_all,activity,subject)
data_averaged<-summarise_each(activity_subject_df,funs(mean))
data_averaged<-arrange(data_averaged,subject)
setwd('..')
setwd('..')
write.table(data_averaged,'averages.txt',row.names = FALSE)


