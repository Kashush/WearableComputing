run_analysis<-function(){

    library(dplyr)
    
    #Read features.txt into a table in order to get the column headings for the raw data
    setwd("C:/Users/Corina/Dropbox/Data Science Specialization/Getting and Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
    tbl<-read.table("features.txt", sep="-", header=FALSE, fill = TRUE)
    
    #Deterine the number of columns.
    colCount=nrow(tbl)
    
    #Determine which columns contain averages or standard deviations.
    colHeadings<-grep("mean()", tbl[,2], fixed=TRUE)
    colHeadings<-c(colHeadings, grep("std()", tbl[,2], fixed=TRUE))
    colHeadings<-sort(colHeadings)
    
    #Import test data.
    testTbl<-read.delim("./test/X_test.txt", header=FALSE, sep=" ", dec = ".", fill = TRUE)
    
    #Import train data.
    trainTbl<-read.delim("./train/X_train.txt", header=FALSE, sep=" ", dec = ".", fill = TRUE)
    
    #Get test data's mean and standard deviation columns.
    testData<-testTbl[,colHeadings]
    
    #Get train data's mean and standard deviation columns.
    trainData<-trainTbl[,colHeadings]
    
    #Merge the two datasets together.
    totalData<-rbind(testData, trainData)
    
    #Add column names to the merged data 
    names(totalData)<-sub("\\s+$", "", paste(gsub("[[:space:]]", "", gsub("[[:digit:]]", "",tbl[colHeadings,1])), gsub("()", "", tbl[colHeadings,2], fixed=TRUE), tbl[colHeadings, 3], sep=" "))
    
    #Summarize the data. Average each measurement.
    AverageTable<-tbl_df(as.data.frame(cbind(names(totalData), colMeans(totalData, na.rm = TRUE))))
    names(AverageTable)<-c("Variable", "Average")

    #Write out the table of Averages.
    write.table(AverageTable, file="AverageTable.txt", sep=",", row.names = FALSE)
}
