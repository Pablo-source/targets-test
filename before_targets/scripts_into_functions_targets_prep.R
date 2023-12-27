# scripts_into_functions_targets_prep

# Function 01: Load data and data wrangling

# 01-01. Original set of scripts
# Read csv
data <- read_csv(here::here("data/Type_I_AE_Attendances_AUG2010_NOV2023_NHS_ENGLAND_website.csv"))
head(data)
# create new variables
date_build <-data %>% 
  mutate(
    Year = substring(Period,4,6),
    Month = substring(Period,1,2),
    Day = 01,
    Yearf = paste0(20,Year),
    date = paste0(Day,"/",Month,"/",Yearf))
date_build
# Format date variable as R date format
data_formatted <- date_build %>% 
  select(Period,date,
         Att_TypeI =`Type 1 Departments - Major A&E`) %>% 
  mutate(Date = as.Date(date, format = "%d/%m/%Y")) %>% 
  select(Date,Att_TypeI)
data_formatted
# Missing value imputation
data_nomiss <- data_formatted %>%   
  mutate(weekday = wday(Date, week_start=1, label =TRUE)) %>% 
  mutate(Att_TypeI = ifelse(is.na(Att_TypeI),
                            lag(Att_TypeI,n=7),Att_TypeI))
data_nomiss

