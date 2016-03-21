# WearableComputing
The input is a zip file containing data collected from the accelerometers from the Samsung Galaxy S smartphone.

The script run_analysis.R will generate a new file named AverageTable.txt that contains average values for the variables that contain means and standard deviations.
Note that the script assumes that the compressed file is in the same directory as the R script.

The script will:
*  Download and unzip the compressed directory getdata-projectfiles-UCI HAR Dataset.zip.
*  Create a list of columns that contain means (averages) and standard deviations from the file features.txt.
*  Merge the test results with the subject and activities found in X_test.txt. subject_test.txt and y_test.txt respectively.
   - First extract the mean and standard deviation columns from X_test.txt
   - Then merge y_test.txt with activity_labels.txt to get a descriptive label of activities.
   - Then merge the tables together
*  Merge the train results with the subject and activities found in X_train.txt. subject_train.txt and y_train.txt respectively.
*  Merge the test and train tables into one table.
*  Add columnn headers.
*  Write the tidy dataset into a comma separated values workbook named "tidyData.csv".
*  Calculate the average for each mean and standard deviation measurement.
*  Write the summary into a text file names "Summary.txt"

