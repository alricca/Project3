

#Data source - Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

#load libraries used in the program

library(plyr)
library(dplyr)
library(reshape2)
library(tidyr)

# create a directory for the data - checking first to see if it already exists
if(!file.exists("./project3")) {dir.create("./project3")}


# download the identified zipped file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(fileUrl, destfile = "./project3/zippedfile", method = "curl")

# get list of fiels contained in zipped file
# use zipped filename vecotr to download teh relevant files

filenames <- unzip("./project3/zippedfile", list = TRUE)
train_files <- filenames[grep(".train.", filenames$Name),]
test_files <- filenames[grep(".test.", filenames$Name),]
unzip("./project3/zippedfile")
labels1 <- read.table(filenames$Name[1])
labels2 <- read.table(filenames$Name[2])
testdata <- read.table(filenames$Name[17])
traindata <- read.table(filenames$Name[31])

# Objective 1 - "Merges the training and the test sets to create one data set."
# accomplished by rbinding the train and test data

all_data <- rbind(testdata, traindata)

# Objective 2 - "Extracts only the measurements on the mean and standard deviation for each measurement."
#  add variable names as column names and grab any variables with names that contain either M/mean of S/std


colnames(all_data) <- labels2[, 2]
a <- grepl("[Mm]ean|[Ss]td", colnames(all_data))
selected_data <- all_data[a]

# download the subject data for the test and train data sets
# bind together and name as "subject" and then bind to the data

rowlabels_test <- read.table(filenames$Name[16])
rowlabels_train <- read.table(filenames$Name[30])
subjects <- rbind(rowlabels_test, rowlabels_train)
colnames(subjects) <- "subject"
selected_data <- cbind(subjects, selected_data)

# download the activity data for the test and train data sets
# bind together and name as "activity" and then bind to the data


activitylabels_test <- read.table(filenames$Name[18])
activitylabels_train <- read.table(filenames$Name[32])
activities <- rbind(activitylabels_test, activitylabels_train)
colnames(activities) <- "activity"
selected_data <- cbind(activities, selected_data)

# Objective 3 - Uses descriptive activity names to name the activities in the data set
# based on the information in activity_labels.txt
# transform the activity codes to their actual meaning

for(i in 1:length(selected_data$activity)) 
  {if(selected_data$activity[i] == 1) {selected_data$activity[i] <- "walking"} else 
    {if(selected_data$activity[i] == 2) {selected_data$activity[i] <- "walking upstairs"} else 
    {if(selected_data$activity[i] == 3) {selected_data$activity[i] <- "walking downstairs"} else 
    {if(selected_data$activity[i] == 4) {selected_data$activity[i] <- "sitting"} else 
    {if(selected_data$activity[i] == 5) {selected_data$activity[i] <- "standing"} else 
    {if(selected_data$activity[i] == 6) {selected_data$activity[i] <- "laying"} else 
              {selected_data$activity[i] <- "no activity"}}
    }}}}}

# Objective 4 - "Appropriately labels the data set with descriptive variable names."
# Expand some of the column labels to more natural language (where I could figure it out)

colnames(selected_data) <- gsub("^t", "time domain - ", colnames(selected_data))
colnames(selected_data) <- gsub("^f", "frequency domain - ", colnames(selected_data))
colnames(selected_data) <- gsub("BodyBody", "body Body", colnames(selected_data))
colnames(selected_data) <- gsub("BodyAcc", "body accelerometer - ", colnames(selected_data))
colnames(selected_data) <- gsub("BodyGyro", "body gyroscope - ", colnames(selected_data))
selected_data$subject <- factor(selected_data$subject)

#  Objective 5 - "From the data set in step 4, creates a second, independent tidy data set with 
#  the average of each variable for each activity and each subject."
#  Melt that data; collect the mean using ddply and then return to the tidy data set using spread
#  Note I chose to go with a 2-D or flat file data set.  
#  using the acast function would create a 3D repreentation - Not sure which is "tidier" 

melted_data <- melt(selected_data, id.vars = c("subject", "activity"))

# For 3-D:
# tidy_data <- acast(melted_data, subject ~ activity ~ variable, fun.aggregate = mean)

# For 2-D:
results <- ddply(melted_data, c("subject", "activity", "variable"), summarize, mean = mean(value))


tidy_data <- spread(results, variable, mean)

# write the tidy data set to the original directory (where the data was stored from the download)

write.table(tidy_data, file = "./project3/tidy_data")



