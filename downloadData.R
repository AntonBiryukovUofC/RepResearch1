downloadData <- function() # Downloads data if not found in the WD
{
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
    
}