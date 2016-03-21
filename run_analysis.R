run_analysis<-function(){

    library(utils)
    library(dplyr)
    library(data.table)
    
    #Go to the github repository clone.
    homeDir<-"C:/Users/Corina/WearableComputing"
    setwd(homeDir)
    
    #Download the compressed file.
    filePath<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(filePath, "inputData.zip", mode = "wb")
    
    #Unzip the compressed file.
    unzip("inputData.zip")
    
    #Read features.txt into a table in order to get the column headings for the raw data
    featuresFile<-"./UCI HAR Dataset/features.txt"
    featuresTable<-read.table(featuresFile, sep="-", header=FALSE, fill = TRUE)
    
    #Determine which columns contain averages or standard deviations.
    featureCol<-grep("mean()", featuresTable[,2], fixed=TRUE)
    featureCol<-c(featureCol, grep("std()", featuresTable[,2], fixed=TRUE))
    featureCol<-sort(featureCol)
    
    #Read in the activity lables.
    activityFile<-"./UCI HAR Dataset/activity_labels.txt"
    activityTbl<-read.table(activityFile)
    
    #Import test data.
    testFile<-"./UCI HAR Dataset/test/X_test.txt"
    testSubject<-"./UCI HAR Dataset/test/subject_test.txt"
    testActivity<-"./UCI HAR Dataset/test/y_test.txt"
    
    totalTestTbl<-read.table(testFile, header=FALSE, row.names = NULL)
    testSubjectTbl<-read.table(testSubject, header=FALSE,row.names = NULL)
    testActivityTbl<-read.table(testActivity, header = FALSE, row.names = NULL)
    
    #Get the mean and standard deviation columns from the test data
    testTbl<-totalTestTbl[,featureCol]
    
    #Add activity lables to the test activity table.
    testActivityTbl<-left_join(testActivityTbl, activityTbl, by = NULL)
    
    #Merge test data into one table.
    testData<-data.table(testSubjectTbl$V1, testActivityTbl$V2)
    testData<-data.table(testData, testTbl)
    
    #Import train data.
    trainFile<-"./UCI HAR Dataset/train/X_train.txt"
    trainSubject<-"./UCI HAR Dataset/train/subject_train.txt"
    trainActivity<-"./UCI HAR Dataset/train/y_train.txt"
    
    totaltrainTbl<-read.table(trainFile, header=FALSE, row.names = NULL)
    trainSubjectTbl<-read.table(trainSubject, header=FALSE,row.names = NULL)
    trainActivityTbl<-read.table(trainActivity, header = FALSE, row.names = NULL)
    
    #Get the mean and standard deviation columns from the train data
    trainTbl<-totaltrainTbl[, featureCol]
    
    #Add activity lables to the train activity table.
    trainActivityTbl<-left_join(trainActivityTbl, activityTbl, by = NULL)
    
    #Merge train data into one table.
    trainData<-data.table(trainSubjectTbl$V1, trainActivityTbl$V2)
    trainData<-data.table(trainData, trainTbl) 
    
    #Merge the two datasets together.
    totalTable<-rbind(testData, trainData)
    
    #Add column names to the merged data 
    namesVector<-sub("\\s+$", "", paste(gsub("[[:space:]]", "", gsub("[[:digit:]]", "",featuresTable[featureCol,1])), gsub("()", "", featuresTable[featureCol,2], fixed=TRUE), featuresTable[featureCol, 3], sep=" "))
    namesVector<-c("Subject", "Activity", namesVector)
    names(totalTable)<-namesVector
    
    #Sort the data.
    totalTable<-arrange(totalTable, Subject, Activity)
    
    #Write out the tidy data set with all the data.
    write.table(totalTable, file="tidyData.csv", sep=",", row.names = FALSE)
    
    #Melt the data
    dataMelt<-melt(totalTable, id=c("Subject", "Activity"))
    
    #Group the data under test subject, activity and variable.
    groupedData<-group_by(dataMelt, Subject, Activity, variable)
    
    #Calculate the mean of each variable.
    summaryTable<-summarise(groupedData, mean(value))
    
    #Write out the summarized data set.
    write.table(summaryTable, file="Summary.txt", sep=",", row.names = FALSE)
    
}
