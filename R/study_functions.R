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
# TARGET 01: Function to import Type1_ATT_file
clean_type1_data <- function(Type1_ATT_file){
  
  data_typeone <- read_csv(Type1_ATT_file,col_types = cols()) %>%
    as_tibble() %>%
    # 1. Rename variables and create date variables
    select(Period, Type1_ATT  = `Type_1_AE_ATT`) %>%
    filter(!is.na(Type1_ATT)) %>%
    select(Period,Type1_ATT)
  data_typeone
}

# TARGET 02: Function to import Type2_ATT_file
clean_type2_data <- function(Type2_ATT_file){
  
  data_typetwo <- read_csv(Type2_ATT_file,col_types = cols()) %>%
    as_tibble() %>%
    # 1. Rename variables and create date variables
    select(Period, Type2_ATT  = `Type_2_AE_ATT`) %>%
    filter(!is.na(Type2_ATT)) %>%
    select(Period,Type2_ATT)
  data_typetwo
}
# TARGET 03: Function to import Type3_ATT_file
clean_type3_data <- function(Type3_ATT_file){
  
  data_typethree <- read_csv(Type3_ATT_file,col_types = cols()) %>%
    as_tibble() %>%
    # 1. Rename variables and create date variables
    select(Period, Type3_ATT  = `Type_3_AE_ATT`) %>%
    filter(!is.na(Type3_ATT)) %>%
    select(Period,Type3_ATT)
  data_typethree
}

# TARGET 04: Combine first two files into one
merge_files <-function(data_typeone,data_typetwo) {
  
  file_one  <- data_typeone
  file_two  <- data_typetwo
  one_two <- left_join(file_one,file_two,
                        by = join_by(Period == Period))
  one_two_combined <-one_two
  write.csv(one_two_combined,here("objects","one_two_combined.csv"), row.names = TRUE)
  one_two_combined # Important always place combined file as standalone object end of function
}

# TARGET 05: Combine merged two previous file and file_three
merge_all_files <-function(one_two_combined,data_typethree) {
  
  file_two_merged <-one_two_combined
  file_three<-data_typethree
  
  all_three_files<-left_join(file_two_merged,file_three,
                              by = join_by(Period == Period))
  
  all_three_files_combined <-all_three_files
  
  write.csv(all_three_files_combined,here("objects","one_two_three_combined.csv"), row.names = TRUE)
  all_three_files_combined # Important always place combined file as standalone object end of function
}

# TARGET 06: Data prep for plots (modified on 26/04/2024)
format_data_plots <- function(all_three_files_combined) {
  
  data_for_plot <- all_three_files_combined %>% 
    mutate(
           Year = substring(Period,5,6),
           Month = substring(Period,1,3),
           Day = 01,
           Yearf = paste0(20,Year),
           date = paste0(Yearf,"/",Month,"/",Day)) %>% 
  mutate(datef = as.Date(date, format = "%Y/%b/%d")) %>% 
  select(datef, Type1_ATT,Type2_ATT,Type3_ATT)
  data_for_plot
}

# TARGET 07: Type_1_ATT plot saved as .png file (modified on 26/04/2024)
# This target outputs a .png file to "object" folder

type_1_plot <- function(data_for_plot){
  
  line_chart <- ggplot(data_for_plot) +
    geom_line(aes(x =datef, y = Type1_ATT)) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) 
  path_out <- here::here("objects","line_chart.png") 
  ggsave(path_out,line_chart)
  line_chart
}

# TARGET 08: Type_1_ATT plot to be used in the Markdown_report (modified on 26/04/2024)
type_1_plot_report <- function(data_for_plot) {
  
  plot_1_report<-ggplot(data_for_plot) +
    geom_line(aes(x=datef, y = Type1_ATT)) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) 
  plot_1_report
}

# TARGET 09: Type_2_ATT plot to be used in the Markdown_report (modified on 26/04/2024)
type_2_plot_report <- function(data_for_plot) {
  
  plot_2_report<-ggplot(data_for_plot) +
    geom_line(aes(x=datef, y = Type2_ATT)) +
    labs(title = "A&E Type II Attendances. 2011-2023 period",
         subtitle = "Type II A&E Attendances by month",
         x = "Period", y = "Type II Attendances" ) 
  plot_2_report
}

# TARGET 10: Type_3_ATT plot to be used in the Markdown_report (modified on 26/04/2024)
type_3_plot_report <- function(data_for_plot) {
  
  plot_3_report<-ggplot(data_for_plot) +
    geom_line(aes(x=datef, y = Type3_ATT)) +
    labs(title = "A&E Type III Attendances. 2011-2023 period",
         subtitle = "Type III A&E Attendances by month",
         x = "Period", y = "Type III Attendances" ) 
  plot_3_report
}
