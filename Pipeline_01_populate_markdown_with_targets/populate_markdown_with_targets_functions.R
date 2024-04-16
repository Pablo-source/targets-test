# Folder: \R
# Pipeline: Pipeline_01_populate_markdown with targets 
# R Script: populate_markdown_with_targets_functions.R

# populate_markdown_with_targets_pre_target.R
# This script tests functions before we create "populate_markdown_with_targets_functions.R" file


# INPUT FILE: Monthly-AE-Time-Series-March-2024.xls

# A&E attendances			
# Period	
# Type 1 Departments - Major A&E	
# Type 2 Departments - Single Specialty	
# Type 3 Departments - Other A&E/Minor Injury Unit	Total Attendances


# TARGET 01: IMPORT EXCEL FILE
clean_ATT_data_function <- function(AE_data_input){
  
  clean_ATT_data <- read_excel(AE_data_input, 
                               col_types = c("date", "numeric", "numeric", 
                                             "numeric", "numeric", "numeric", "numeric", "numeric", 
                                             "numeric", "numeric", "numeric", "numeric", "numeric", 
                                             "numeric", "text", "numeric", "numeric"), skip = 13) %>% 
                               clean_names() %>% 
                    select(period,
                             AE_att_TypeI_dbl = type_1_departments_major_a_e,
                             AE_att_TypeII_dbl =  type_2_departments_single_specialty,
                             AE_att_TypeIII_dbl = type_3_departments_other_a_e_minor_injury_unit,
                             Total_attendances = total_attendances) %>% 
                     mutate(date = as.Date(period)) %>%                    # Works fine up to this point
                     mutate(
                             AE_att_TypeI = as.integer(AE_att_TypeI_dbl),
                             AE_att_TypeII = as.integer(AE_att_TypeII_dbl),
                             AE_att_TypeIII = as.integer(AE_att_TypeIII_dbl)
                           ) %>% 
                 select(date,AE_att_TypeI,AE_att_TypeII,AE_att_TypeIII)
  clean_ATT_data
  
}


# TARGET 02: Write out ATT_Type_I into one .csv file 
ATT_Type_I_clean_function <- function(clean_ATT_data){

   ATT_Type_I  <- clean_ATT_data %>% select(date,AE_att_TypeI)
      
      ATT_Type_I_csv <- ATT_Type_I
      write.csv(ATT_Type_I_csv,here("data","Monthly-AE-Time-Series-March-2024_ATT_TypeI.csv"),row.names = TRUE)
   
   ATT_Type_I
   
}

# TARGET 03: Write out ATT_Type_II into one .csv file 
ATT_Type_II_clean_function <- function(clean_ATT_data){
  
  ATT_Type_II  <- clean_ATT_data %>% select(date,AE_att_TypeII)
  
    ATT_Type_II_csv <- ATT_Type_II
    write.csv(ATT_Type_II_csv,here("data","Monthly-AE-Time-Series-March-2024_ATT_TypeII.csv"),row.names = TRUE)
  
  ATT_Type_II
  
}

# TARGET 04: Write out ATT_Type_III into one .csv file 
ATT_Type_III_clean_function <- function(clean_ATT_data){
  
  ATT_Type_III  <- clean_ATT_data %>% select(date,AE_att_TypeIII)
  
  ATT_Type_III_csv <- ATT_Type_III
  write.csv(ATT_Type_III_csv,here("data","Monthly-AE-Time-Series-March-2024_ATT_TypeIII.csv"),row.names = TRUE)
  
  ATT_Type_III
  
}

#  TARGET 05: AE_att_TypeI plot 
#  clean_ATT_data %>% select(date,AE_att_TypeI)

type_1_plot <- function(clean_ATT_data) {
  
  line_chart_AE_att_TypeI <- ggplot(clean_ATT_data) +
    geom_line(aes(x =date, y = AE_att_TypeI)) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) 
  
  path_out <- here::here("objects","AE_att_TypeI_chart.png") 
  ggsave(path_out,line_chart_AE_att_TypeI)
  
  line_chart_AE_att_TypeI
}

#  TARGET 06: AE_att_TypeII plot
#  clean_ATT_data %>% select(date,AE_att_TypeII)
type_2_plot <- function(clean_ATT_data) {
  
  line_chart_AE_att_TypeII <- ggplot(clean_ATT_data) +
    geom_line(aes(x =date, y = AE_att_TypeII)) +
    labs(title = "A&E Type II Attendances. 2011-2023 period",
         subtitle = "Type II A&E Attendances by month",
         x = "Period", y = "Type II Attendances" ) 
  
  path_out <- here::here("objects","AE_att_TypeII_chart.png") 
  ggsave(path_out,line_chart_AE_att_TypeII)
  
  line_chart_AE_att_TypeII
}

# TARGETS 07: AE_att_TypeIII plot 
# clean_ATT_data %>% select(date,AE_att_TypeIII)

type_3_plot <- function(clean_ATT_data) {
  
  line_chart_AE_att_TypeIII <- ggplot(clean_ATT_data) +
    geom_line(aes(x =date, y = AE_att_TypeIII)) +
    labs(title = "A&E Type III Attendances. 2011-2023 period",
         subtitle = "Type III A&E Attendances by month",
         x = "Period", y = "Type III Attendances" ) 
  
  path_out <- here::here("objects","AE_att_TypeIII_chart.png") 
  ggsave(path_out,line_chart_AE_att_TypeIII)
  
  line_chart_AE_att_TypeIII
}


