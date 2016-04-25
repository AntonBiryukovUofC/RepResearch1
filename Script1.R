
# Loading the necessary packages :
library(dplyr) # Great package to work with dfs
library(tidyr) # ^^
library(ggplot2) # For plotting I just love ggplot2
library(lubridate) # For working with the dates
activity_list <- tbl_df(read.csv("./activity.csv")) # Read the data into a dataframe
activity_list_1 <- activity_list %>% filter(!is.na(steps)) %>%  # Filter the NAs
  group_by(date) %>% # Group by the date
  summarize(StepsPerDay = sum(steps)) # Sum of the steps elements in each group
activity_list_2 <- activity_list %>% filter(!is.na(steps)) %>%  # Filter the NAs
  group_by(date) %>% # Group by the date
  summarize(StepsPerDay = sum(steps)) # Sum of the steps elements in each group

p <- qplot(StepsPerDay,data = activity_list_1,geom = "histogram",bins = 20)
Mean_Median <-as.data.frame(t(c(mean(activity_list_1$StepsPerDay),median(activity_list_1$StepsPerDay))))
colnames(Mean_Median) <- c("Mean of steps per day","Median of steps per day")
print(Mean_Median)
print(p)