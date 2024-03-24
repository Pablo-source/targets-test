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
  one_two <- right_join(file_one,file_two,
                        by = join_by(Period == Period))
  one_two_combined <-one_two
  write.csv(one_two_combined,here("objects","one_two_combined.csv"), row.names = TRUE)
  one_two_combined # Important always place combined file as standalone object end of function
}

# TARGET 05: Combine merged two previous file and file_three
merge_all_files <-function(one_two_combined,data_typethree) {
  
  file_two_merged <-one_two_combined
  file_three<-data_typethree
  
  all_three_files<-right_join(file_two_merged,file_three,
                              by = join_by(Period == Period))
  
  all_three_files_combined <-all_three_files
  
  write.csv(all_three_files_combined,here("objects","one_two_three_combined.csv"), row.names = TRUE)
  all_three_files_combined # Important always place combined file as standalone object end of function
}

# TARGET 06: Data prep for plots
format_data_plots <- function(all_three_files_combined) {
  
  data_for_plot <- all_three_files_combined %>% 
    mutate(
           Year = substring(Period,5,6),
           Month = substring(Period,1,3),
           Day = 01,
           Yearf = paste0(20,Year),
           date = paste0(Yearf,"/",Month,"/",Day)) %>% 
  mutate(datef = as.Date(date, format = "%Y/%b/%d"))
  data_for_plot
}
