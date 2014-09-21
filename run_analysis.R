#setting work space for computation
setwd("/media/removable/USB Drive/Data Science/R Programming - Class 3/UCI HAR Dataset")

#getting global vaviables for each data set
featureLable <- read.table("features.txt")
featureLable <- featureLable$V2

#importing the data sets train
subTrain <- read.table("./train/subject_train.txt")
subTrainX <- read.table("./train/X_train.txt")
subTrainY <- read.table("./train/Y_train.txt")
colnames(subTrain) <- c("subject")
colnames(subTrainX) <- featureLable
colnames(subTrainY) <- c("training")


#importing the data sets Test
subTest <- read.table("./test/subject_test.txt")
subTestX <- read.table("./test/X_test.txt")
subTestY <- read.table("./test/Y_test.txt")
colnames(subTest) <- c("subject")
colnames(subTestX) <- featureLable
colnames(subTestY) <- c("training")

#creating filter lists for mean and std dev
filterListMean <- as.vector(featureLable[grep(glob2rx("*mean()*"),featureLable)])
filterListSTD <- as.vector(featureLable[grep(glob2rx("*std()*"),featureLable)])

#Filtering the large data set
filterMeanSTD <- c(filterListMean,filterListSTD)
subTrainX <- subTrainX[filterMeanSTD]
subTestX <- subTestX[filterMeanSTD]

#joing the data
masterTrain <- cbind(subTrain,subTrainY,subTrainX)
masterTest <- cbind(subTest,subTestY,subTestX)

#joining Train and Test
allData <- rbind(masterTrain, masterTest)
allData <- arrange(allData, subject, training)

#labeling the training data
allData$training[allData$training == "1"] <- "WALKING"
allData$training[allData$training == "2"] <- "WALKING_UPSTAIRS"
allData$training[allData$training == "3"] <- "WALKING_DOWNSTAIRS"
allData$training[allData$training == "4"] <- "SITTING"
allData$training[allData$training == "5"] <- "STANDING"
allData$training[allData$training == "6"] <- "LAYING"

#Step 5 averaging the data set
dataMelt <- melt(allData, measure.vars=filterMeanSTD)
newDF <- dcast(dataMelt, subject + training ~ variable, mean)

#Last step, save the data out 
write.table(newDF, file="run_analysis_DF",row.names=FALSE)