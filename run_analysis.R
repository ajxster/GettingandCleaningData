# 1 Loading data #

## 1.1 Features names ##
setwd("C:/Users/User/Documents/UCI HAR Dataset/")
features <- read.table("features.txt")

## 1.2 Test data ##
setwd("C:/Users/User/Documents/UCI HAR Dataset/test")
subjecttest <- read.table("subject_test.txt")
xtest <- read.table("X_test.txt", col.names = features[,2])
ytest <- read.table("Y_test.txt")

## 1.3 Train data ##
setwd("C:/Users/User/Documents/UCI HAR Dataset/train")
xtrain <- read.table("X_train.txt", col.names = features[,2])
ytrain <- read.table("Y_train.txt")
subjecttrain <- read.table("subject_train.txt")

# 2 Merging #

## 2.1 Adding subject id column to train and test data ##
xtestsubject <- cbind(xtest, subjecttest)
colnames(xtestsubject)[which(names(xtestsubject) == "V1")] <- "subject"
xtrainsubject <- cbind(xtrain, subjecttrain)
colnames(xtrainsubject)[which(names(xtrainsubject) == "V1")] <- "subject"

## 2.2 Adding activity column ##
xytestsubject <- cbind(xtestsubject, ytest)
colnames(xytestsubject)[which(names(xytestsubject) == "V1")] <- "activity"
xytrainsubject <- cbind(xtrainsubject, ytrain)
colnames(xytrainsubject)[which(names(xytrainsubject) == "V1")] <- "activity"

## 2.3 Merging test and train data ##
completedata <- rbind(xytestsubject, xytrainsubject)

# 3 Extracting columns with mean or std of measurements #

## 3.1 Finding columns with mean or std in its name ##
validcols <- grep("mean()|std()", features[,2])

## 3.2 Creating a data set with variables "subject", "activity" and those with mean and std in its name ##
datameanstd <- completedata[,c(562, 563, validcols)]

## 3.3 Recoding activity number id into activity name ##
datameanstd$activity[datameanstd$activity == 1] <- "walking"
datameanstd$activity[datameanstd$activity == 2] <- "walking_upstairs"
datameanstd$activity[datameanstd$activity == 3] <- "walking_downstairs"
datameanstd$activity[datameanstd$activity == 4] <- "sitting"
datameanstd$activity[datameanstd$activity == 5] <- "standing"
datameanstd$activity[datameanstd$activity == 6] <- "laying"

## 3.4 Labeling with friendly descriptive variable names ##
names(datameanstd) <- gsub(names(datameanstd), pattern = "\\.", replacement = "")

# 4 Creating a tidy data set with the averages of mean and std measurements by subject and activity #

tidydata <- aggregate(datameanstd, list(subject = datameanstd$subject, activity = datameanstd$activity), mean)
tidydata[3:4] <- list(NULL)

# 5 Exporting data set #
write.table(tidydata, file = "Data.txt", row.names = FALSE)