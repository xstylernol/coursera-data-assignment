library(dplyr)
library(reshape2)

features <- read.table("features.txt", nrows = -1)
activitylabels <- read.table("activity_labels.txt", nrows = -1)

trainx <- read.table("train\\X_train.txt", nrows = -1)
trainy <- read.table("train\\y_train.txt", nrows = -1)
trainsub <- read.table("train\\subject_train.txt", nrows = -1)
testx <- read.table("test\\X_test.txt", nrows = -1)
testy <- read.table("test\\y_test.txt", nrows = -1)
testsub <- read.table("test\\subject_test.txt", nrows = -1)

#Combine all the labels and the two data sets together
names(testsub) <- c("subjectid")
names(trainsub) <- c("subjectid")
names(testy) <- c("activityid")
names(trainy) <- c("activityid")
testdata <- cbind(testsub, testy, testx)
traindata <- cbind(trainsub, trainy, trainx)
alldata <- rbind(testdata, traindata)


#Question 2
#Find features with only functions to calculate a mean or std
#(so yes to mean(), yes to meanFreq(), but no to angle(Z,gravityMean)
stdmeancols <- grepl("(mean|std)(.*)\\(\\)", features$V2, ignore.case = TRUE)
stdmeancols <- c(TRUE, TRUE, stdmeancols )
#Extract the data of only the mean and std
stdmeandata <- alldata[, stdmeancols]

#Question 3
#Merge the activity names and drop the activity id
names(activitylabels) <- c("activityid","activity")
alldata <- merge(activitylabels, alldata)
alldata <- alldata[,2:ncol(alldata)]

#Question 4
#Label the variables
names(alldata)[3:ncol(alldata)] <- as.character(features$V2)

#Question 5
#Melt the data, find the mean of each variable by activity and subject id
# Tidy data
# 1) Each variable in a column (variables = subjectid, activity, and mean value)
# 2) Each observation of mean (for each activity and subject) forms a row
# 3) The one table stores data from the activity tracker
meltdata <- melt(alldata, id=c("activity", "subjectid"), measure.vars=names(alldata)[3:ncol(alldata)])
meltdata$subjectid <- as.factor(meltdata$subjectid)
#Convert the variables from factor to character so that duplicated feature names will be treated as the same
#For example, "fBodyAcc-bandsEnergy()-1,16" appears in the features list three times
meltdata$variable <- as.character(meltdata$variable)
meanmeltdata <- summarize(group_by(meltdata, activity, subjectid, variable), meanvalue = mean(value))
write.table(meanmeltdata, file = "tidydatanarrow.txt", row.names = FALSE)
