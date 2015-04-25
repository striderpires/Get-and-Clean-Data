# Running this R script will create the tidy data set and save it as "tidyDataset.txt"

# Read files beginning with X
# * fPath = path of the file
# * fFeatures = filtered feature ids to be extracted
# * features: all feature names
readBaseSet <- function(fPath, fFeatures, features) {
        cols_widths <- rep(-16, length(features))
        cols_widths[fFeatures] <- 16
        rawSet <- read.fwf(
                file=fPath,
                widths=cols_widths,
                col.names=features[fFeatures])
}

# Reads an additional file (other than the base sets). Used for subjects and labels.
# * dataDirectory = directory of data
# * fPath = relative path of the file. For instance if its value is "subject" it
#   will read "UCI HAR Dataset/test/subject_test.txt" and "UCI HAR Dataset/train/subject_train.txt", and merge them
rAdditionalFile <- function(dataDirectory, fPath) {
        fPathTest <- paste(dataDirectory, "/test/", fPath, "_test.txt", sep="")
        fPathTrain <- paste(dataDirectory, "/train/", fPath, "_train.txt", sep="")
        data <- c(read.table(fPathTest)[,"V1"], read.table(fPathTrain)[,"V1"])
        data
}

# Correcting feature names - Removes parentheses for a tidier dataframe layout
# * featureName = name of the feature
correctFeatureName <- function(featureName) {
        featureName <- gsub("\\(", "", featureName)
        featureName <- gsub("\\)", "", featureName)
        featureName
}

# Read sets, returning a complete set
# * dataDirectory = directory of data
readSets <- function(dataDirectory) {
        # Adding main data files (X_train and X_test)
        featuresFilePath <- paste(dataDirectory, "/features.txt", sep="")
        features <- read.table(featuresFilePath)[,"V2"]
        filteredFeatures <- sort(union(grep("mean\\(\\)", features), grep("std\\(\\)", features)))
        features <- correctFeatureName(features)
        d <- readBaseSet(paste(dataDirectory, "/test/X_test.txt", sep=""), filteredFeatures, features)
        d <- rbind(d, readBaseSet(paste(dataDirectory, "/train/X_train.txt", sep=""), filteredFeatures, features))
        # Adding subjects
        d$subject <- rAdditionalFile("UCI HAR Dataset", "subject")
        
        # Adding activities
        activitiesFilePath <- paste(dataDirectory, "/activity_labels.txt", sep="")
        activities <- read.table(activitiesFilePath)[,"V2"]
        d$activity <- activities[rAdditionalFile("UCI HAR Dataset", "y")]
        
        d
}

dataDirectory <- "UCI HAR Dataset"
if (!file.exists(dataDirectory)) {
        url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        tmp_file <- "./temp.zip"
        download.file(url,tmp_file, method="curl")
        unzip(tmp_file, exdir="./")
        unlink(tmp_file)
}

# From d we create the tidy dataset via a summary
# * dataDirectory = directory of data
SummaryDataset <- function(dataDirectory) {
        e <- readSets(dataDirectory)
        e_x <- e[,seq(1, length(names(e)) - 2)]
        summary_by <- by(e_x,paste(e$subject, e$activity, sep="_"), FUN=colMeans)
        summary <- do.call(rbind, summary_by)
        summary
}

summary <- SummaryDataset(dataDirectory)
write.table(summary, "tidyDataset.txt")