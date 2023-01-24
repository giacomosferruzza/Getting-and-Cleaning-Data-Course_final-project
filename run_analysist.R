library(dplyr)
library (tidyr)

#Merges the training and the test sets to create one data set.

features <- read.table ("features.txt")
subject_test <- read.table ("test/subject_test.txt")
y_test <- read.table ("test/y_test.txt")
X_test <- read.table ("test/X_test.txt")
colnames (X_test) <- features [,2]
database_test <- cbind (subject_test, y_test, X_test)

subject_train <- read.table ("train/subject_train.txt")
y_train <- read.table ("train/y_train.txt")
X_train <- read.table ("train/X_train.txt")
colnames (X_train) <- features [,2]
database_train <- cbind (subject_train, y_train, X_train)
database <- rbind (database_train, database_test)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
vet <- grepl ("-mean\\()", colnames (database)) | grepl ("-std\\()", colnames (database))  
vet [c(1,2)] <- TRUE #save the first 2 columns! 
database <- database [,vet]

#Uses descriptive activity names to name the activities in the data set
activity_labels  <- read.table ("activity_labels.txt")
subst <- function (x) {
  activity_labels[grepl (x, activity_labels[,1]),2]
}
Labl <- sapply (as.list (database[,2]), subst)
database[,2] <- Labl

#Appropriately labels the data set with descriptive variable names. 
colnames (database) [c(1,2)] <- c("id", "activity")
names (database) <- gsub ("-","",names (database))
names (database) <- tolower (names(database))
names (database) <- gsub ( "\\()" ,"",names (database))

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
database1 <- summarize_all(group_by (database, id, activity), mean) 
database1 <- gather (database1, variab, value, -c(1:2)) #put all the features in a column 
database1 [,5] <- substr(database1$variab, 1,1) #extract the domain viariable from the features 
database1 [,6] <- gsub (FALSE, "", gsub (" ", "" ,(paste ((sub (TRUE, "mean", grepl("mean",database1$variab))),(sub (TRUE, "std", grepl("std",database1$variab))))))) #extract the index (mean or std) viariables from the features 
database1 [,7] <- gsub (FALSE, "", gsub (" ", "" ,(paste (sub (TRUE, "x", grepl ("x$", database1$variab)), sub (TRUE, "y", grepl ("y$", database1$variab)), sub (TRUE, "z", grepl ("z$", database1$variab)), 
                                                          sub (TRUE, "magnitude", grepl ("mag", database1$variab))))))  #extract the 3D parameter (X, Y, Z or magnitude) viariable frome the features 

#I also tried to create a "jerk" variabe (jerk vs notjerk), however I found the new database less  

#remove from the feature string the informations already extracted
database1 [,3] <- gsub ("mean", "",database1$variab) 
database1 [,3] <- gsub ("std", "",database1$variab)
database1 [,3] <- gsub ("mag", "",database1$variab)
database1 [,3] <- gsub ("^t", "",database1$variab)
database1 [,3] <- gsub ("^f", "",database1$variab)
database1 [,3] <- gsub ("x$", "",database1$variab)
database1 [,3] <- gsub ("y$", "",database1$variab)
database1 [,3] <- gsub ("z$", "",database1$variab)
database1 [,3] <- gsub ("bodyb", "b",database1$variab) #some variable is called bodybody, not reported in the feature_info file.. is a mistake? 
database1 <- spread(database1,key = "variab",value = "value")  #put back the features in the columns 
colnames (database1) [c(3,4,5)] <- c("domain", "index", "3dsignal") #properly name the columns


write.table(database1, "database1.txt")
