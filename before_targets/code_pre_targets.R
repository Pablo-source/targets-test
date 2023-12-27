# code_pre_targets.R 

library(tidyverse)
library(here)

# read data
data <- read_csv(here::here("data/Type_I_AE_Attendances_AUG2010_NOV2023_NHS_ENGLAND_website.csv"))
head(data)

date_build <-data %>% 
           mutate(
             Year = substring(Period,4,6),
             Month = substring(Period,1,2),
             Day = 01,
             Yearf = paste0(20,Year),
             date = paste0(Day,"/",Month,"/",Yearf))
             ##mutate(datef = as.Date(date, format = "%Y/%b/%d"))
date_build

# Transform date into a date variable
data_formatted <- date_build %>% 
                  select(Period,date,
                         Att_TypeI =`Type 1 Departments - Major A&E`) %>% 
  ### format = "%d/%m/%Y")
                  mutate(Date = as.Date(date, format = "%d/%m/%Y")) %>% 
                  select(Date,Att_TypeI)
data_formatted

## Check missing values
miss_Vals <- data_formatted %>% 
             filter(is.null(Att_TypeI))
miss_Vals

## Function to replace missing values by same value previous week
Date <-c(2010-08-01,2010-09-01,2010-10-01,2010-11-01,2010-12-01,
         2011-01-01,2011-02-01,2011-03-01,2011-04-01,2011-05-01)
Values <-c(1138652,1150728,1163143,1111295,1159204,
           1133881,1053707,NA, 1197213,NA)
length(Date)
length(Values)
Test_data <- cbind.data.frame(Date,Values)  
Test_data

Test_data_input <- Test_data %>% 
                   mutate(
                     Values_fill = ifelse(is.na(Values),0,Values)
                     ,
                     Lagged_Values = lag(Values,n=7)
                   )
Test_data_input

