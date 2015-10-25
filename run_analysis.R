##For course project - loads data and adds variable names from features.txt

##Prepare Train Data
setwd("C:/Users/home/Desktop/R_Files/Coursera/getting_cleaning_data/Project/UCI HAR Dataset")

##Loads train data observations, labels, subjects and features:
X_train <- read.table("./train/X_train.txt", header=TRUE, quote="\"")

Y_train <- read.table("./train/Y_train.txt", header=TRUE, quote="\"")

subject_train <- read.table("./train/subject_train.txt", header=TRUE, quote="\"")

features <- read.table("./features.txt")

##Applies feature names to X_train:
colnames(Y_train)<-"Activity"
colnames(X_train)<-features[,2]
colnames(subject_train) <- "Subject"

##Binds subjects, labels and observations:

train <- cbind(subject_train,Y_train,X_train)

##Prepare Test Data

##Loads train data observations, labels, subjects and features:

X_test <- read.table("./test/X_test.txt", header=TRUE, quote="\"")

Y_test <- read.table("./test/Y_test.txt", header=TRUE, quote="\"")

subject_test <- read.table("./test/subject_test.txt", header=TRUE, quote="\"")

##Applies feature names to X_test:
colnames(Y_test)<-"Activity"
colnames(X_test)<-features[,2]
colnames(subject_test) <- "Subject"

##Binds subjects, labels and observations:

test <- cbind(subject_test,Y_test,X_test)

##Binds train and test into one new data structure - data

data<-rbind(train, test)

##Select columns with mean or std in name using dplyr package
library(dplyr)

data_ms<-data[,grep(".*mean.*|.*std.*",colnames(data))]

##Attach the activity names according to the activity code - using sqldf package

activity_labels <- read.table(".activity_labels.txt", header=FALSE, quote="\"")

library(sqldf)

data_tmp<-data[,1:2]
data_act<-sqldf("select A.*, B.V2 as Activity_Name 
                from data_tmp as A
                left join activity_labels as B
                on A.Activity = B.V1")

data_clean<-cbind(data_act,data_ms)


## Final table with averages of each variable grouped by each activity and subject

output<-data_clean %>% group_by(Subject,Activity_Name) %>% summarise_each(funs(mean))

output2<-output[with(output,order(Activity,Subject)),]

##Creates the output tidy data file

write.table(output2,"tidy_data.txt",row.names=FALSE,quote=FALSE)






