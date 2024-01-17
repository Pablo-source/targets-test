# study_functions.R

# Turned set of scripts into a function with input and outputs and arguments
# This function below is going to be sourced from /R folder

# 1. Data preparation stages

## Source all files in R folder
source_all <- function(path = "R"){
  files <- list.files(here::here(path),
                      full.names = TRUE,
                      pattern = "R$")
  suppressMessages(lapply(files,source))
  invisible(path)
}


# Function 01: Clean data
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
         mutate(Datef = as.Date(date, format = "%d/%m/%Y")) %>% 
         select(Datef,Att) %>%   
    #  3. Account for missing values
    # This line below displays weekdays as character Mon,Tue, Wed..
        mutate(weekday = wday(Datef, week_start=1, label =TRUE)) %>% 
        mutate(Att_TypeI = ifelse(is.na(Att),
                              lag(Att,n=7),Att)) %>% 
        filter(!is.na(Att_TypeI)) %>% 
        select(Datef,Att_TypeI)
  
  data
}

# Function 02: Plot data
# The only argument is going to be "data" for the input coming from the previous function

plot_data <- function(data){
    
  ggplot(data) +
  geom_line(aes(x =Datef, y = Att_TypeI)) +
  labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) 
  

}

# Function 03: Save plot in folder 

save_plot <- function(data){
  
  line_chart <-    ggplot(data) +
    geom_line(aes(x =Datef, y = Att_TypeI)) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) 
  
  path_out <- here::here("objects","line_chart.png") 
  ggsave(path_out,line_chart)
  
}

## 2. Set of Forecast functions required for Targets pipeline

# Function 03: Data prep for ARIMA and TBATS models

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
    mutate(Min_date = min(Date), Max_date = max(Date)) %>% 
    
    forecast_data_prep
  # 5. write.csv(Forecast_models_out,here("objects","ALL_MODELS_forecast.csv"), row.names = TRUE)
  write.csv(forecast_data_prep,here("objects","Data_prep_for_forecast.csv"), row.names = TRUE)
}