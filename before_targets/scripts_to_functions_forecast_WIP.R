# R Script: scripts_to_functions_forecast_models.R
# Folder: /before_targets
# WIP
# Turning content from script "code_pre_targets_univariate_fcast_models_wip.R"

# AIM: Turn all data steps and model creation steps from "code_pre_targets_univariate_fcast_models_wip.R"
#      into a set of two or tree functions to create new set of targets from them.
 
library(tidyverse)
library(here)

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

# 2. Transform date into a date variable
data_formatted <- data_build %>% 
  select(date,Att) %>% 
  ### format = "%d/%m/%Y")
  mutate(Date = as.Date(date, format = "%d/%m/%Y")) %>% 
  select(Date,Att)

#  3. Account for missing values
data_nomiss <- data_formatted %>%   
  # This line below displays weekdays as character Mon,Tue, Wed..
  mutate(weekday = wday(Date, week_start=1, label =TRUE)) %>% 
  mutate(Att_TypeI = ifelse(is.na(Att),
                            lag(Att,n=7),Att)) %>% 
  filter(!is.na(Att_TypeI))

# 5. Turn data into TS object

# 5.1 Implement a ARIMA model 
# https://spureconomics.com/arima-and-sarima-in-rstudio/

AE_type2_ts_prep <- data_nomiss %>% 
  select(Date, Att_TypeI) %>%
  mutate(Min_date = min(Date), Max_date = max(Date))

AE_type2_ts_date_v <- AE_type2_ts_prep[,1]
AE_type2_ts <- AE_type2_ts_prep[,2]

# In our example or data is monthly so we will adjust frequency to 12
# Start will be "2010-08-01" Aug 2010 (2010,8)
# End will be "2023-11-01" Nov 2023 (2023,11)

AE_type2_to_ts <- data_nomiss %>% 
  select(Date, Att_TypeI) %>%
  mutate(Min_date = min(Date), Max_date = max(Date)) %>% 
  select(Att_TypeI)

library(stats)

AE_type2_ts <- ts(AE_type2_to_ts[,1], start = c(2010, 8), end = c(2023, 11), frequency = 12)
# 6. Create an ARIMA model and forecast next 6 months
library(forecast)
arima_model <- auto.arima(AE_type2_ts)

# Series: AE_type2_ts 
# ARIMA(1,1,0)(2,0,0)[12]

# 2.2 Forecast next 12 periods using ARIOMA model

tail(data_nomiss)
arima_forecast <- forecast(arima_model)

# 5.2 Implement a SARIMA model 
# Create a SARIMA model and forecast next 12 months
# From previuos ARIMA model (1,1,0)
# By adding (seasonal = TRUE) paarameter to the auto.arima() function
sarima110 <- auto.arima(AE_type2_ts, seasonal = TRUE)

# 7 Create a TBATS model and forecast next 6 months 
tbats_fit <-tbats(AE_type2_ts)

# Check first on which month actual data end
tbats_prediction <- predict(tbats_fit, np=4)


## 8 Bundle together ARIMA and TBATS predictions
arima_pred_df <- as.data.frame(arima_forecast)
tbats_pred_df <- as.data.frame(tbats_prediction)

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

ARIMA_dates <- cbind.data.frame(Fcasted_dates,arima_pred_df) %>% 
  select(Fcasted_dates,'Point Forecast','Lo 95','Hi 95') %>% 
  mutate(Model = 'ARIMA', 
         weekday = wday(Fcasted_dates, week_start=1, label =TRUE)) %>% 
  slice(1:12) # Keeping 12 first months of forecasted values
ARIMA_dates


write.csv(ARIMA_dates,here("objects","ARIMA_12M_forecast.csv"), row.names = TRUE)

TBATS_dates <- cbind.data.frame(Fcasted_dates,tbats_pred_df) %>% 
  select(Fcasted_dates,'Point Forecast','Lo 95','Hi 95') %>% 
  mutate(Model = 'TBATS', 
         weekday = wday(Fcasted_dates, week_start=1, label =TRUE)) %>% 
  slice(1:12) # Keeping 12 first months of forecasted values
TBATS_dates

# write.csv(TBATS_dates,here("objects","TBATS_forecast.csv"), row.names = TRUE)
write.csv(TBATS_dates,here("objects","TBATS_12M_forecast.csv"), row.names = TRUE)


# Combine both models and wrote output as .csv file
Forecast_models <- rbind.data.frame(ARIMA_dates,TBATS_dates)

Forecast_models_out <- Forecast_models %>% select("Fcasted_dates","Point Forecast","Lo 95","Hi 95",Model,weekday)

names(Forecast_models)

# write.csv(Forecast_models_out,here("objects","ALL_MODELS_forecast.csv"), row.names = TRUE)
write.csv(Forecast_models_out,here("objects","ALL_MODELS_12_M_forecast.csv"), row.names = TRUE)

## 9 Combine Actual and Forecasted values into a single data frame 
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
         Model,
         weekday)%>% 
  mutate(Type = "Forecast")




names(Forecast_data)
names(Actual_data)


Actual_and_forecast_output <-  Actual_data %>% 
  bind_rows(Forecast_data) %>% 
  select(Date, Att_TypeI, weekday, Type, Low_95_CI, High_95_CI, Model)

Actual_and_forecast_output

write.csv(Actual_and_forecast_output,here("objects","Actual_and_forecast_output.csv"), row.names = TRUE)

