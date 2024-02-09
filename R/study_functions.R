# study_functions.R
# saved in /R folder

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

# Set of TARGETS functions defined in this pipeline
# TARGET 01: Function> clean_data(file) | target name in pipeline: data
# TARGET 02: Function> plot_data(data)  | target name in pipeline: plot
# TARGET 03: Function> save_plot(data)  | target name in pipeline: savemyplot 
# TARGET 04: Function> fcast_data_prep(data) | target name in pipeline: data_prep_models


# TARGET 01: Function> clean_data(file) | target name in pipeline: data
# Function 01: Clean data
# The only argument is going to be "file_csv" for the input .csv we are going to import

clean_data <- function(file_csv){
  
  data <- read_csv(file_csv,col_types = cols()) %>% 
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

# TARGET 02: Function> plot_data(data)  | target name in pipeline: plot
# Function 02: Plot data
# The only argument is going to be "data" for the input coming from the previous function

plot_data <- function(data){
  
  ggplot(data) +
    geom_line(aes(x =Datef, y = Att_TypeI)) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) 
  
  
}

# TARGET 03: Function> save_plot(data)  | target name in pipeline: savemyplot 
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

# TARGET 04: Function> fcast_data_prep(data) | target name in pipeline: data_prep_models
# Function 03: Data prep and TS models

fcast_data_prep <- function(data){
  
  # 1. Get data from previous target object clean data set is called "data" from initial target object
  #     for this analysis
  data_prep_model <- data %>% 
    select(Datef,Att_TypeI) %>% 
    mutate(Min_date = min(Datef),
           Max_date = max(Datef)) %>% 
    # 3. Replace if any missing values by same value previous week
    mutate(weekday = wday(Datef, week_start=1, label =TRUE)) %>% 
    mutate(Att_TypeI = ifelse(is.na(Att_TypeI),
                              lag(Att_TypeI,n=7),Att_TypeI)) %>% 
    filter(!is.na(Att_TypeI))
  data_prep_model
  # 5. write.csv(Forecast_models_out,here("objects","ALL_MODELS_forecast.csv"), row.names = TRUE)
  write.csv(data_prep_model,here("objects","data_prep_model.csv"), row.names = TRUE)
  
  
}