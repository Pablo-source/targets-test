# study_functions.R

# Turned set of scripts into a function with input and outputs and arguments
# This function below is going to be sourced from /R folder

## Source all files in R folder
source_all <- function(path = "R"){
  files <- list.files(here::here(path),
                      full.names = TRUE,
                      pattern = "R$")
  suppressMessages(lapply(files,source))
  invisible(path)
}


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

# Function 02-02: Plot data
# The only argument is going to be "data" for the input coming from the previous function

plot_data <- function(data){
    
line_chart <-    ggplot(data) +
  geom_line(aes(x =Datef, y = Att_TypeI)) +
  labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) 
  
  path_out <- here::here("objects","line_chart.png") 
  ggsave(path_out,line_chart)
 
}
