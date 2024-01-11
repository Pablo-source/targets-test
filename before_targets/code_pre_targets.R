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

# 5. Turn data into TS object

# 5.1 Implement a ARIMA model 
# https://spureconomics.com/arima-and-sarima-in-rstudio/

AE_type2_ts_prep <- data_nomiss %>% 
                    select(Date, Att_TypeI) %>%
                    mutate(Min_date = min(Date), Max_date = max(Date))
AE_type2_ts_prep

# House_price_ts_prep data set
# First column:
AE_type2_ts_date_v <- AE_type2_ts_prep[,1]
# Second column: 
AE_type2_ts <- AE_type2_ts_prep[,2]

# In our example or data is monthly so we will adjust frequency to 12
# Start will be "2010-08-01" Aug 2010 (2010,8)
# End will be "2023-11-01" Nov 2023 (2023,11)

AE_type2_to_ts <- data_nomiss %>% 
                  select(Date, Att_TypeI) %>%
                  mutate(Min_date = min(Date), Max_date = max(Date)) %>% 
                  select(Att_TypeI)
AE_type2_to_ts

library(stats)

AE_type2_ts <- ts(AE_type2_to_ts[,1], start = c(2010, 8), end = c(2023, 11), frequency = 12)
AE_type2_ts

# 6. Create an ARIMA model and forecast next 12 months

library(forecast)
arima_model <- auto.arima(AE_type2_ts)

# Series: AE_type2_ts 
# ARIMA(1,1,0)(2,0,0)[12]

# 2.2 Forecast next 12 periods
arima_forecast <- forecast(arima_model, h=12)

# 5.2 Implement a SARIMA model 
# Create a SARIMA model and forecast next 12 months
# From previuos ARIMA model (1,1,0)
# By adding (seasonal = TRUE) paarameter to the auto.arima() function
sarima110 <- auto.arima(AE_type2_ts, seasonal = TRUE)
sarima110