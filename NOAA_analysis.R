# Load the necessary libraries:
library("dplyr")
library("lubridate")
library("ggplot2")
library("sqldf")
library(R.utils)
dir.create("./Data/")
# Check whether the data file is present in the folder:
if (!file.exists("./Data/StormData.csv.bz2"))
{
    # Download the file:
    fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
    download.file(fileUrl,"./Data/StormData.csv.bz2")
}
# Ready to work with the data:
# Step 1: read the data
# Will read a subset of the Big Storm dataset (~10%):
work_on_subset <- TRUE

# If the data is not in the memory yet:
if (!exists("stormData"))
{
    bunzip2("./Data/StormData.csv.bz2", "./Data/Storm_dataset.csv", remove = FALSE, skip = TRUE)
    # Get the header, put it in the subset:
    system("head -1 ./Data/Storm_dataset.csv > ./Data/Storm_subset.csv")
    system("perl -ne 'print if (rand() < 0.10)' ./Data/Storm_dataset.csv > ./Data/Storm_subset.csv")
    if (work_on_subset){
        stormData <- read.csv("Storm_subset.csv")    
    }
    else{
        stormData <- read.csv("Storm_dataset.csv")
    }
    
}
