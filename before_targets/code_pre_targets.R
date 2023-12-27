# code_pre_targets.R script

library(tidyverse)
library(here)

# 1. read data
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

# 2. Transform date into a date variable
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

## Custom function to replace missing values by same value previous week

# Create dummy data set
Date <-as.Date(c("2023-12-06","2023-12-07","2023-12-08","2023-12-09","2023-12-10",
         "2023-12-11","2023-12-12","2023-12-13","2023-12-14","2023-12-15"),
         format = "%Y-%m-%d")
Values <-c(1138652,1150728,1163143,1111295,1159204,
           1133881,1053707,NA, 1197213,NA)
length(Date)
length(Values)
Test_data <- cbind.data.frame(Date,Values)  
Test_data

# 1-2, Set of transforamations required to replace missing value by same day 
# previous week value.
Test_data_input <- Test_data %>%  
                  # Display weekday (assuming week starts on Monday )
                  mutate(weekday = wday(Date, week_start=1, label =TRUE)) %>% 
                  # Input missing values by same day previos week
                  # Day of the week assumes week starts on Monday (Monday=1)
                  mutate(Values_fill = ifelse(is.na(Values),
                          lag(Values,n=7),Values))
Test_data_input

# 2-2 Turn above code into a function
Input_prev_week <- function(){
  Inputted <- Test_data %>%  
    # Display weekday (assuming week starts on Monday )
    mutate(weekday = wday(Date, week_start=1, label =TRUE)) %>% 
    # Input missing values by same day previos week (7 days before current date)
    # Day of the week assumes week starts on Monday (Monday=1)
    mutate(Values_fill = ifelse(is.na(Values),
                                lag(Values,n=7),Values))
  Inputted
}  

# Apply function on Test_data data set
# Assumming we have a data set called Test_data
# Made of two variables "Date" on first column and "Values" on second column
Input_prev_week()

# 3. Account for missing values if any
# Replacing any existing missing value by same day previous week value
data_nomiss <- data_formatted %>%   
               mutate(weekday = wday(Date, week_start=1, label =TRUE)) %>% 
               mutate(Att_TypeI = ifelse(is.na(Att_TypeI),
                                         lag(Att_TypeI,n=7),Att_TypeI)) %>% 
              filter(!is.na(Att_TypeI))
  
data_nomiss

# 4. Visualize data 
Line_chart <-   data_nomiss %>% 
  select(Date,Att_TypeI) %>% 
  ggplot(aes(x = Date, y = Att_TypeI, colour = "darkorange1")) +
  geom_line(size=1,  linetype=1, show.legend = FALSE) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
       subtitle ="Type I A&E Attendances by month",
       # Change X and Y axis labels
       x = "Period", 
       y = "Type I Attendances") +
  theme_light() 

Line_chart 
  
ggsave("plots/01 Monthly A&E Type I Attendances 2011-2013.png", width = 6, height = 4)
  
  
