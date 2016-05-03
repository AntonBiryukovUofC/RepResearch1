# Load the necessary libraries:
library("dplyr")
library("lubridate")
library("ggplot2")
library("R.utils")
# This function downloads data if necessary:
source("./downloadData.R")
downloadData()
message("Digesting the data")
# Ready to work with the data:
# Step 1: read the data
# Will read a subset of the Big Storm dataset (nrows = n_row):
work_on_subset <- FALSE
n_row <-  200000
# If the data is not in the memory yet:
if (!exists("stormData") )
{
    # Unzip the data
    if (!file.exists("./Data/Storm_dataset.csv")){
        message("unzipping the data")
        bunzip2("./Data/StormData.csv.bz2", "./Data/Storm_dataset.csv", remove = FALSE, skip = TRUE)
        message("Done unzipping!")
        
    }
    message("Forming a subset of data")
    if (work_on_subset){
        stormData <- tbl_df(read.csv("./Data/Storm_dataset.csv",nrows = n_row))
    }
    else{
        stormData <- tbl_df(read.csv("./Data/Storm_dataset.csv"))
    }
}
message("Moving on to cleaning the data")
################ At this point data is in the memory, moving onto cleaning
# Establish the mapping from K and M to 10^3 and 10^6
exp_val <- c(1E3,1E6,1E9)
names(exp_val) <- c("K","M","B")  # All numbers are then in $$$
kmb_to_exp <- function(x,exp_val){
    
    if (toupper(x) %in% names(exp_val)) y <- as.numeric(exp_val[toupper(x)])
    else y <- NA
    
}    
message("Converting the exponential corrections for damage factors")
message("... and filtering NAs after")


# Question 2 #####

storm_Data_PROP <- stormData %>%
    mutate(PROPDMGEXP_ADJ = sapply(PROPDMGEXP,kmb_to_exp,exp_val)) %>%
    mutate(CROPDMGEXP_ADJ = sapply(CROPDMGEXP,kmb_to_exp,exp_val) ) %>%
    filter(!is.na(PROPDMG) & !is.na(PROPDMGEXP_ADJ))

# Subdivide the event types:
message("Now subdividing the event types into 7 types, chosen from 95% of the data")

keywords =c("HAIL","WIND","TORNADO|FUNNEL","FLOOD|FLD","LIGHTNING","SNOW|WINTER|ICE","RAIN|WATER")
strings <- storm_Data_PROP$EVTYPE
table_greps <- sapply(keywords, grepl, strings, ignore.case=TRUE)
message("Looking for the keywords in the EVTYPE")

evtypes_df <- arrange(tbl_df(as.data.frame(which(table_greps==TRUE,arr.ind = TRUE ))),row) %>% mutate(EVtype = keywords[col])
Evtypes <- array(rep(NA,length(strings)))
Evtypes[as.array(evtypes_df$row)] = evtypes_df$EVtype # Assign subsetted event type according to the row number
message("Computing the total damage costs, and grouping it according to the subtype")

storm_Data_Table <- storm_Data_PROP %>%
    mutate(Total_Dmg_Corrected = sum(c(PROPDMG*PROPDMGEXP_ADJ,CROPDMG*CROPDMGEXP_ADJ),na.rm=TRUE)) %>% # Apply the exp correction and sum the impact
    mutate(eventType = Evtypes) %>% # Aggregate the types of the events into 7 subtypes
    filter(!is.na(eventType)) %>%
    filter(STATE %in% state.abb) %>%
    group_by(STATE,eventType) %>% # Group by the event type
    summarize(total_dmg = sum(Total_Dmg_Corrected)) # Sum the damage per event type

p3 <- ggplot(data = storm_Data_Table,aes(x=STATE,y=total_dmg,fill = factor(eventType))) + geom_bar(stat="identity")+
    theme(axis.text.x = element_text(size=10))
# QUESTION 1
# Drop the NA in the injuries and fatalities


storm_Data_health_Table <- storm_Data_PROP %>%
    mutate(eventType = Evtypes) %>% # Aggregate the types of the events into 7 subtypes
    filter(!(is.na(FATALITIES) | is.na(INJURIES))) %>%
    filter(!is.na(eventType)) %>%
    filter(STATE %in% state.abb) %>%
    group_by(STATE,eventType) %>% 
    summarize(fatal_sum = sum(FATALITIES), inj_sum= sum(INJURIES))
    
    
    
p1 <- ggplot(data = storm_Data_health_Table,aes(x=STATE,y=fatal_sum,fill = factor(eventType))) + geom_bar(stat="identity")+
    theme(axis.text.x = element_text(size=10))
p2 <- ggplot(data = storm_Data_health_Table,aes(x=STATE,y=inj_sum,fill = factor(eventType))) + geom_bar(stat="identity",position="stack")+
    theme(axis.text.x = element_text(size=10))



stop("YO BRO")


