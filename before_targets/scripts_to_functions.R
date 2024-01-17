# scripts_to_functions.R

library(tidyverse)
library(here)
# We will create just TWO functions: 
# 1. Read in and process raw data
# 2. Create plot
# Creating Function 01-02. Read in and process raw data from set of scripts
# Original scripts from "code_pre_targets.R" script
# we use read_csv() function from {readr} package included in {tidyverse}
# Function read_csv creates a tibble
here_i_am  <- here::here()
here_i_am

list.files (pattern = "csv$")

# [1] "Type_I_AE_Attendances_AUG2010_NOV2023.csv"
data <- read_csv(here("Type_I_AE_Attendances_AUG2010_NOV2023.csv"),col_names = TRUE)
data

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


# Turn this set of scripts into a function with input and outputs and arguments
# This function below is going to be sourced from /R folder

# Function 01-02: Clean data
# The only argument is going to be "file" for the input .csv we are going to import

clean_data <- function(file){
  
  data <- read_csv(file,col_types = cols()) %>% 
    as_tibble() %>% 
    # 1. Rename variables and create date variables
    select(Date = Period,Att = `Type 1 Departments - Major A&E`) %>% 
    mutate(Year = substring(Date,4,6),Month = substring(Date,1,2),Day = 01,
           Yearf = paste0(20,Year),
           date = paste0(Day,"/",Month,"/",Yearf)) %>% 
    select(date,Att) %>% 
    mutate(Date = as.Date(date, format = "%d/%m/%Y")) %>% 
    select(Date,Att) %>%   
    #  3. Account for missing values
    # This line below displays weekdays as character Mon,Tue, Wed..
    mutate(weekday = wday(Date, week_start=1, label =TRUE)) %>% 
    mutate(Att_TypeI = ifelse(is.na(Att),
                              lag(Att,n=7),Att)) %>% 
    filter(!is.na(Att_TypeI))
  
  data
}

# 2. Plot data
# Original scripts from "code_pre_targets.R" script
Line_chart <- data_nomiss %>% 
  select(Date, Att_TypeI) %>% 
  ggplot(aes(x = Date, y = Att_TypeI, colour = "darkorange1")) +
  geom_line(linewidth = 1, linetype=1, show.legend = FALSE) +
  labs(title = "A&E Type I Attendances. 2011-2023 period",
       subtitle = "Type I A&E Attendances by month",
       x = "Period", y = "Type I Attendances" ) +
  theme_light()
Line_chart

# Function 02-02: Plot data
# The only argument is going to be "data" for the input coming from the previous function

plot_data <- function(data){
  
  Line_chart <- data %>% 
    select(Date, Att_TypeI) %>% 
    ggplot(aes(x = Date, y = Att_TypeI, colour = "darkorange1")) +
    geom_line(linewidth = 1, linetype=1, show.legend = FALSE) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) +
    theme_light() %>% 
    ggsave("plots/01 Monthly A&E Type I Attendances 2011-2013.png", width = 6, height = 4)
  Line_chart
}

# Function 03: Data prep and TS models

fcast_data_prep <- function(data){
  
  # 1. Get data from previous target object clean data set is called "data" from initial target object
  #     for this analysis
  forecast_data_prep <- data %>% 
    select(Date = Period,
           Att = `Type 1 Departments - Major A&E`) %>% 
    mutate(
      Year = substring(Date,4,6),
      Month = substring(Date,1,2),
      Day = 01,
      Yearf = paste0(20,Year),
      date = paste0(Day,"/",Month,"/",Yearf)) %>% 
    # 2. Transform date into a date variable
    select(date,Att) %>% 
    ### format = "%d/%m/%Y")
    mutate(Date = as.Date(date, format = "%d/%m/%Y")) %>% 
    select(Date,Att) %>% 
    # 2.1 Format Date variable format = "%d/%m/%Y")
    mutate(Date = as.Date(date, format = "%d/%m/%Y")) %>% 
    select(Date,Att) %>%
    # 3. Replace if any missing values by same value previous week
    mutate(weekday = wday(Date, week_start=1, label =TRUE)) %>% 
    mutate(Att_TypeI = ifelse(is.na(Att),
                              lag(Att,n=7),Att)) %>% 
    filter(!is.na(Att_TypeI)) %>% 
    # 4. Turn initial Data Frame into a TS object
    select(Date, Att_TypeI) %>%
    mutate(Min_date = min(Date), Max_date = max(Date))

forecast_data_prep
    # 5. write.csv(Forecast_models_out,here("objects","ALL_MODELS_forecast.csv"), row.names = TRUE)
    write.csv(forecast_data_prep,here("objects","Data_prep_for_forecast.csv"), row.names = TRUE)
  
  
}