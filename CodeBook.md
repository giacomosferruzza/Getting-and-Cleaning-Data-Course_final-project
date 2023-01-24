title: "CodeBook"
author: "Giacomo Sferruzza"
date: '2023-01-23'
output: html_document
---
### **Variables**

- ID: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- activity: activity performed during the sampling. The six activities ara: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
- domain: prefix 't' to denote domain signals; prefix 'f' to indicate frequency domain signals
- index:mean or std 
- 3dsignal: 3-axial raw signals (x, y, z) or calculated magnitude of these three-dimensional signals
- bodyacc: body acceleration signal
- bodyaccjerk: body acceleration signal derived in time
- bodygyro: body angular velocity 
- bodygyrojerk:body angular velocity derived in time
- gravityacc: gravity acceleration signal



### **Data**

For each variable the the sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). As required in the project, the average of each variable for each activity and each subject is reported in the final database (database1). 

### **Clean up pipeline**

Once the data were imported on R and "train" and "test" and the column names were imported from the "feature" database, the data were merged. 
Only the columns containing mean or standard deviation were selected as required. 
After that, sapply and a new function called "subst" were used to exchange the activity code with descriptive activity names, as defined in the activity_labels dataset. 
To make tidier the database, the characters "()" and "-" were removed and the uppercase letters were exchanged with lowercase letters. 
An independent tidy data set, named database1 with the average of each variable for each activity and each subject was created. 
Database1 resulted was messy because each column contains more than 1 variable. So I used the gather function to put the features in the same column and extract variables from them (like domain, index, and 3dsignal). 
I removed the extracted data from the feature names to make the database tidier and finally, I put again the few remained features as columns, using the "spread" function
