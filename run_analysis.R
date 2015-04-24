# Data:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Merge data
train_X <- read.table("train/X_train.txt")
test_X <- read.table("test/X_test.txt")
data_x <- rbind(train_X, test_X)

rm("train_X")
rm("test_X")

train_Y <- read.table("train/y_train.txt")
test_Y <- read.table("test/y_test.txt")
data_y <- rbind(train_Y, test_Y)

rm("train_Y")
rm("test_Y")


train_subject <- read.table("train/subject_train.txt")
test_subject <- read.table("test/subject_test.txt")
data_subject <- rbind(train_subject, test_subject)

rm("train_subject")
rm("test_subject")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
means_std <- grep("-mean()|-std()", features[, 2])
data_x <- data_x[, means_std]
names(data_x) <- tolower(gsub("\\(|\\)", "", features[means_std, 2]))


# 3. Uses descriptive activity names to name the activities in the data set

activities <- read.table("activity_labels.txt")
activities[,2] <- tolower(gsub("_","",activities[,2]))
names(activities) <- c("activity_id", "activities")
names(data_y) <- ("activity_id")
library("sqldf")
data_y<- sqldf("select a.activities from data_y y, activities a WHERE a.activity_id=y.activity_id")

# 4. Appropriately labels the data set with descriptive variable names. 
names(data_subject) <- ("subject")
data_combined <- cbind(data_subject, data_y, data_x)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_data <- aggregate(. ~subject + activities, data_combined, mean)
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)