# code_pre_targets.R

# code pre targets - Analysis to be run before incorporating it to TARGETS ##
# Create a pipeline to run several Univariate models  # 
# ARIMA, TBATS #

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

tail(data_nomiss)

AE_type2_ts_date_v <- AE_type2_ts_prep[,1]
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

# 6. Create an ARIMA model and forecast next 6 months

library(forecast)
arima_model <- auto.arima(AE_type2_ts)

# Series: AE_type2_ts 
# ARIMA(1,1,0)(2,0,0)[12]

# 2.2 Forecast next 12 periods using ARIOMA model

# Check first on which month actual data end
tail(data_nomiss)

arima_forecast <- forecast(arima_model)
arima_forecast
# 5.2 Implement a SARIMA model 
# Create a SARIMA model and forecast next 12 months
# From previuos ARIMA model (1,1,0)
# By adding (seasonal = TRUE) paarameter to the auto.arima() function
sarima110 <- auto.arima(AE_type2_ts, seasonal = TRUE)
sarima110

# 7 Create a TBATS model and forecast next 6 months 
tbats_fit <-tbats(AE_type2_ts)
tbats_fit

# Check first on which month actual data end
tail(data_nomiss)

tbats_prediction <- predict(tbats_fit, np=4)
tbats_prediction

## 8 Bundle together ARIMA and TBATS predictions
arima_pred_df <- as.data.frame(arima_forecast)
arima_pred_df
names(arima_pred_df)

tbats_pred_df <- as.data.frame(tbats_prediction)
tbats_pred_df

# 8.1 Create date variable to match actual values
# Create new sequence of dates for forecasted values data frame
# https://uc-r.github.io/date_sequences/

Fcasted_dates <-seq(as.Date('2023-12-01'), as.Date('2025-11-01'), by = "months")
Fcasted_dates

names(arima_forecast)

ARIMA_dates <- cbind.data.frame(Fcasted_dates,arima_pred_df) %>% 
               select(Fcasted_dates,'Point Forecast','Lo 95','Hi 95') %>% 
               mutate(Model = 'ARIMA', 
               weekday = wday(Fcasted_dates, week_start=1, label =TRUE))
ARIMA_dates

write.csv(ARIMA_dates,here("objects","ARIMA_forecast.csv"), row.names = TRUE)

TBATS_dates <- cbind.data.frame(Fcasted_dates,tbats_pred_df) %>% 
              select(Fcasted_dates,'Point Forecast','Lo 95','Hi 95') %>% 
              mutate(Model = 'TBATS') 
TBATS_dates
write.csv(TBATS_dates,here("objects","TBATS_forecast.csv"), row.names = TRUE)

# Combine both models and wrote output as .csv file
Forecast_models <- rbind.data.frame(ARIMA_dates,TBATS_dates)
Forecast_models

Forecast_models_out <- Forecast_models %>% select("Fcasted_dates","Point Forecast","Lo 95","Hi 95","Model")
Forecast_models_out

names(Forecast_models)
write.csv(Forecast_models_out,here("objects","ALL_MODELS_forecast.csv"), row.names = TRUE)

# Read in .csv file removing redundant X column
Forecast_checks <-read.table(here("objects", "ALL_MODELS_forecast.csv"),
                           header =TRUE, sep =',',stringsAsFactors =TRUE) %>% 
                  select(-c(X))

## 9 Combine Actual and Forecasted values into a single data frame 
# Sun 14 Jan
# Actual values data set: data_nomiss
# Forecasted values data set:  Forecast_models_out
tail(data_nomiss)
tail(Forecast_models_out)

# 9.1 Create new Type variable to identify Actual and Forecasted values
names(data_nomiss)
Actual_data <- data_nomiss %>% 
               select(Date, Att_TypeI, weekday) %>% 
               mutate(Type = "Actual")
Actual_data
tail(Actual_data)

names(Forecast_models_out)
Forecast_data <- Forecast_models_out %>% 
                 select(Date = Fcasted_dates, 
                        Att_TypeI = 'Point Forecast',
                        Low_95_CI = 'Lo 95',
                        High_95_CI = 'Hi 95',
                        Model)%>% 
                mutate(Type = "Forecast")

Forecast_data

# 9.2 Union both Actual and Forecast data to create model outupt data frame
# In DPLYR append rows from one or more dataframe to another, use dplyr 's bind_rows() function

Actual_Model_output <-  Actual_data %>% 
                        bind_rows(Forecast_data)
Actual_Model_output
