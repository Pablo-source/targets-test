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

data_formatted <- date_build %>% 
                  select(Period,
                         date,
                         Att_TypeI =`Type 1 Departments - Major A&E`)
data_formatted


