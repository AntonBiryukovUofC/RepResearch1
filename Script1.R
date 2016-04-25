
# Loading the necessary packages :
library(dplyr) # Great package to work with dfs
library(tidyr) # ^^
library(ggplot2) # For plotting I just love ggplot2
library(lubridate) # For working with the dates
library(grid)
library(gridExtra)

# Function to do imputation
imputeNA <- function(steps,interval,Int_averages)
{ # If Steps has NA -> replace with a mean for that interval
for (i in 1:length(steps))
{
  step = steps[i]
  if (is.na(step)){
    steps[i] = Int_averages$StepsPerInt[Int_averages$interval ==interval[i]]
  } 
}
  steps
}


activity_list <- tbl_df(read.csv("./activity.csv")) # Read the data into a dataframe
# Dataset grouped by date
activity_list_1 <- activity_list %>% filter(!is.na(steps)) %>%  # Filter the NAs
  group_by(date) %>% # Group by the date
  summarize(StepsPerDay = sum(steps)) # Sum of the steps elements in each group
# Dataset grouped by interval
activity_list_2 <- activity_list %>% filter(!is.na(steps)) %>%  # Filter the NAs
  group_by(interval) %>% # Group by the interval
  summarize(StepsPerInt = mean(steps)) # Sum of the steps elements in each group

# Before imputing values
p1 <- qplot(StepsPerDay,data = activity_list_1,geom = "histogram",bins = 20,main="Histogram of total steps per day")
Mean_Median <-as.data.frame(t(c(mean(activity_list_1$StepsPerDay),median(activity_list_1$StepsPerDay))))
colnames(Mean_Median) <- c("Mean of steps per day","Median of steps per day")
p2 <- qplot(interval,StepsPerInt,data = activity_list_2,geom="line",main=" Average # steps per interval")
grid.arrange(p1,p2,ncol=2)
print(Mean_Median)
# Now impute the values: I will use the mean for the corresponding interval:
activity_list_3 <- activity_list %>% mutate(stepsImp = imputeNA(steps,interval,activity_list_2))







