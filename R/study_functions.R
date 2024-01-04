# study_functions.R

# Turned set of scripts into a function with input and outputs and arguments
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
