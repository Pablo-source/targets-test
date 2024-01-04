# code_pre_targets.R

# Initial analysis used to generate a report that we will turn into a pipeline.
# This first file is the entire analysis into a single script
# we will turn it into functions to be used within {targets} library

# It is considered good practise to test the entire report script before building the pipeline,
# to check the input and outputs work as expected

library(tidyverse)
library(here)

# 1. Read data
# we use read_csv() function from {readr} package included in {tidyverse}
# read_csv() creates a tibble

here_i_am <- here::here()
here_i_am

list.files("data/",".csv")

# [1] "Type_I_AE_Attendances_AUG2010_NOV2023.csv"


data(head)

data_build <- data %>% 
  select(Date = Period,
         Att = `Type 1 Departments - Major A&E`) %>% 
  mutate(
    Year = substring(Date,4,6),
    Month = substring(Date,1,2),
    Day = 01,
    Yearf = paste0(20,Year),
    date = paste0(Day,"/",Month,"/",Yearf))

data_build

# 2. Transform date into a date variable
data_formatted <- data_build %>% 
  select(date,Att) %>% 
  ### format = "%d/%m/%Y")
  mutate(Date = as.Date(date, format = "%d/%m/%Y")) %>% 
  select(Date,Att)
data_formatted

#  3. Account for missing values
data_nomiss <- data_formatted %>%   
  # This line below displays weekdays as character Mon,Tue, Wed..
  mutate(weekday = wday(Date, week_start=1, label =TRUE)) %>% 
  mutate(Att_TypeI = ifelse(is.na(Att),
                            lag(Att,n=7),Att)) %>% 
  filter(!is.na(Att_TypeI))

data_nomiss

# 4. Plot data
Line_chart <- data_nomiss %>% 
  select(Date, Att_TypeI) %>% 
  ggplot(aes(x = Date, y = Att_TypeI, colour = "darkorange1")) +
  geom_line(linewidth = 1, linetype=1, show.legend = FALSE) +
  labs(title = "A&E Type I Attendances. 2011-2023 period",
       subtitle = "Type I A&E Attendances by month",
       x = "Period", y = "Type I Attendances" ) +
  theme_light()
Line_chart
