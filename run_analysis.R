setwd("C:/Users/Andrey/Documents/Lab-4/UCI HAR Dataset")

train_x <- read.table("./train/X_train.txt")
train_y <- read.table("./train/y_train.txt")
train_subject <- read.table("./train/subject_train.txt")
test_x <- read.table("./test/X_test.txt")
test_y <- read.table("./test/y_test.txt")
test_subject <- read.table("./test/subject_test.txt")

trainData <- cbind(train_subject, train_y, train_x)
testData <- cbind(test_subject, test_y, test_x)

MergeData <- rbind(trainData, testData)

Feature <- read.table("./features.txt", stringsAsFactors = FALSE)[,2]

FeatureIndex <- grep(("mean\\(\\)|std\\(\\)"), Feature)
DATA <- MergeData[, c(1, 2, FeatureIndex+2)]
colnames(DATA) <- c("subject", "activity", Feature[FeatureIndex])

ActivityName <- read.table("./activity_labels.txt")

DATA$activity <- factor(DATA$activity, levels = ActivityName[,1], labels = ActivityName[,2])

names(DATA) <- gsub("\\()", "", names(DATA))
names(DATA) <- gsub("^t", "time", names(DATA))
names(DATA) <- gsub("^f", "frequence", names(DATA))
names(DATA) <- gsub("-mean", "Mean", names(DATA))
names(DATA) <- gsub("-std", "Std", names(DATA))

library(plyr)
tidyData<-aggregate(. ~subject + activity, DATA, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]

write.table(tidyData, file = "tidyData.txt",row.name=FALSE)