library(reshape2)

# 1. Merges the training and the test sets to create one data set.
setwd("C:/Users/joshu/datascience/r_class/Course 3/UCI HAR Dataset")

# Train Data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/Y_train.txt")
s_train <- read.table("train/subject_train.txt")

# Test Data
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/Y_test.txt")
s_test <- read.table("test/subject_test.txt")

# Concat the data 
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table('features.txt')
activity <- read.table('activity_labels.txt')

col_nums <- grep("-(mean|std).*", features[, 2]) # regex that looks for mean or std
col_names <- features[col_nums, 2]


col_names <- gsub("-mean", "Mean", col_names)
col_names <- gsub("-std", "Std", col_names)
col_names <- gsub("[-()]", "", col_names)

# 3. Uses descriptive activity names to name the activities in the data set

all_x_data <- x_data[col_nums]
all_data <- cbind(s_data, all_x_data, y_data)
colnames(all_data) <- c('Subject', 'Activity', col_names)

# 4. Appropriately labels the data set with descriptive variable names. 

all_data$Activity <- factor(all_data$Activity, levels = activity[,1], labels = activity[,2])
all_data$Subject <- as.factor(all_data$Subject)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.

all_data_melt <- melt(all_data, id = c("Subject", "Activity"))
all_data_mean <- dcast(all_data_melt, Subject + Activity ~ variable, mean)

write.table(all_data_mean, "tidy.txt", row.names = FALSE, quote = FALSE)
