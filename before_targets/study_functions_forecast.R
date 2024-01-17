# study_functions.R

# Turned set of scripts into a function with input and outputs and arguments
# This function below is going to be sourced from /R folder

# Function 01: Clean data
# The only argument is going to be "file" for the input .csv we are going to import

clean_data <- function(file){
  
  read_csv(file,col_types = cols()) %>% 
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
    select(Datef,weekday,Att_TypeI)

}

# Function 02: Plot data 
# The only argument is going to be "data" for the input coming from the previous function

plot_data <- function(data){
  
    data %>% 
    select(Datef, Att_TypeI) %>% 
    ggplot(aes(x = Datef, y = Att_TypeI, colour = "darkorange1")) +
    geom_line(linewidth = 1, linetype=1, show.legend = FALSE) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) +
    theme_light() %>% 
    ggsave("plots/01 Monthly A&E Type I Attendances 2011-2013.png", width = 6, height = 4)
  
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