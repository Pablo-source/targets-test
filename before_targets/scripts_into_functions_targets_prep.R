# scripts_into_functions_targets_prep.R script

# Function 01: Load data and data wrangling

# 01-02. Original set of scripts
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

# Turn this set of scripts into a function with input and outputs and arguments
# This function below is going to be sourced from /R folder

clean_data <- function(file) {
  
  data <- read_csv(file) %>% 
            mutate(
              Year = substring(Period,4,6),Month = substring(Period,1,2),Day = 01,
              Yearf = paste0(20,Year),
              date = paste0(Day,"/",Month,"/",Yearf)) %>% 
  
            select(Period,date,
                   Att_TypeI =`Type 1 Departments - Major A&E`) %>% 
            mutate(Date = as.Date(date, format = "%d/%m/%Y")) %>% 
            select(Date,Att_TypeI)  %>%   
            mutate(weekday = wday(Date, week_start=1, label =TRUE)) %>% 
            mutate(Att_TypeI = ifelse(is.na(Att_TypeI),
                                        lag(Att_TypeI,n=7),Att_TypeI)) %>% 
            filter(!is.na(Att_TypeI))
  
data
}

# 02-02. Original set of scripts
# Plot data
Line_chart <-   data %>% 
  select(Date,Att_TypeI) %>% 
  ggplot(aes(x = Date, y = Att_TypeI, colour = "darkorange1")) +
  geom_line(size=1,  linetype=1, show.legend = FALSE) +
  labs(title = "A&E Type I Attendances. 2011-2023 period",
       subtitle ="Type I A&E Attendances by month",
       # Change X and Y axis labels
       x = "Period", 
       y = "Type I Attendances") +
  theme_light() 

Line_chart 

ggsave("plots/01 Monthly A&E Type I Attendances 2011-2013.png", width = 6, height = 4)

# Turn this set of scripts into a function with input and outputs and arguments
# This function below is going to be sourced from /R folder 

plot_data <- function(data) {
  
  Line_chart <- data %>% 
    select(Date,Att_TypeI) %>% 
    ggplot(aes(x = Date, y = Att_TypeI, colour = "darkorange1")) +
    geom_line(size=1,  linetype=1, show.legend = FALSE) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle ="Type I A&E Attendances by month",
         # Change X and Y axis labels
         x = "Period", 
         y = "Type I Attendances") +
    theme_light() %>% 
    ggsave("plots/01 Monthly A&E Type I Attendances 2011-2013.png", width = 6, height = 4)
  
  Line_chart 
}

