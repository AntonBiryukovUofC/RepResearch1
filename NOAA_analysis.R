# Load the necessary libraries:
library("dplyr")
library("lubridate")
library("ggplot2")
library("R.utils")
if (!file.exists("./Data"))
{
    dir.create("./Data/")
}
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
n_row <-  20000
# If the data is not in the memory yet:
if (!exists("stormData"))
{
    # Unzip the data
    if (!file.exists("./Data/Storm_dataset.csv")){
        print("unzipping the data")
        bunzip2("./Data/StormData.csv.bz2", "./Data/Storm_dataset.csv", remove = FALSE, skip = TRUE)
        print("Done unzipping!")
        
    }
    
    # Get the header, put it in the subset later:
    print("Forming a subset of data")
    if (work_on_subset){
        stormData <- read.csv("./Data/Storm_dataset.csv",nrows = n_row)
    }
    else{
        stormData <- read.csv("./Data/Storm_dataset.csv")
    }
    
}
