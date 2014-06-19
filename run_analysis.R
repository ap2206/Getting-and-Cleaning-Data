library(data.table)

#Begin by downloading and unzipping the data file that you need and placing it in the appropriate directory of choice
#Next, I use the setwd() command to set the working directory

setwd("/ap2206/UCI HAR Dataset")

#read the following tables: test data, test activity, and test subject
test_data <- read.table("./test/X_test.txt",header=FALSE)
test_data_activity <- read.table("./test/y_test.txt",header=FALSE)
test_data_subject <- read.table("./test/subject_test.txt",header=FALSE)

#read the following tables: training data, training activity, and training subject
train_data <- read.table("./train/X_train.txt",header=FALSE)
train_data_activity <- read.table("./train/y_train.txt",header=FALSE)
train_data_subject <- read.table("./train/subject_train.txt",header=FALSE)

# 1. Merge the training and the test sets to create one data set. The new data set is called test_and_train_data
test_and_train_data <- rbind(test_data,train_data)

# 2. Extracts only the measuremetns on the mean and standard deviation for each measurement
test_and_train_data_sd <- sapply(test_and_train_data, sd, na.rm=TRUE)
test_and_train_data_mean <- sapply(test_and_train_data, mean, na.rm=TRUE)

# 3. Uses descriptive activity names to name the activities columns in the test and train data activites tables
activities <- read.table("./activity_labels.txt",header=FALSE,colClasses="character")
test_data_activity$V1 <- factor(test_data_activity$V1,levels=activities$V1,labels=activities$V2)
train_data_activity$V1 <- factor(train_data_activity$V1,levels=activities$V1,labels=activities$V2)

# 4. Appropriately labels the data set with descriptive activity names
# read the features file and lable the columns in the combined test and train data table
features <- read.table("./features.txt",header=FALSE,colClasses="character")
colnames(test_and_train_data)<-features$V2

#column bind test and train activities and subject data tables
test_activity_and_subject <- cbind(test_data_activity,test_data_subject)
train_activity_and_subject <- cbind(train_data_activity,train_data_subject)

#row bind test and train activity and subject tables into on table called all_activity_and_subject
all_activity_and_subject <- rbind(test_activity_and_subject, train_activity_and_subject)

#name the columns in the all_activity_and_subject table
colnames(all_activity_and_subject)<-c("Activity","Subject")

#column bind the test and train table with the activities and subject table for one big table that has everything main_data 
main_data <- cbind (test_and_train_data, all_activity_and_subject)

# 5. Creates a second, independent tidy data table with the average of each variable for each activity and each subject.
tidy_data_table <- data.table(main_data)
#sbuset the new_tidy table by activity and by subject, and then write the table out to a .csv file tidy.csv
new_tidy<-tidy_data_table[,lapply(.SD,mean),by="Activity,Subject"]
write.table(new_tidy,file="../ap2206/tidy.csv",sep=",",row.names = FALSE)