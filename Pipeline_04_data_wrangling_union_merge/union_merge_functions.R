#-------------------
# Script: pipeline_functions.R
# It must be saved under \WorkingDir\R folder to work 
# It must be ran from \WorkingDir folder to work properly on work laptop.

# Set of TARGETS functions defined in this pipeline
# TARGET 01: Function to import Type1_ATT_file

# TYPE I

# TARGET01: Type_I_2010
clean_type1_data_2010 <- function(Type1_ATT_file_2010){
  
  data_typeone_10 <- read_csv(Type1_ATT_file_2010,col_types = cols()) %>%
    as_tibble() %>%
    # 1. Rename variables and create date variables
    select(Period, Type1_ATT  = `Type_1_AE_ATT`) %>%
    filter(!is.na(Type1_ATT)) %>%
    select(Period,Type1_ATT)
  data_typeone_10
}

# TARGET02: Type_I_2011_2020
clean_type1_data_2010_20 <- function(Type1_ATT_file_2011_2020){
  
  data_typeone_1020 <- read_csv(Type1_ATT_file_2011_2020,col_types = cols()) %>%
    as_tibble() %>%
    # 1. Rename variables and create date variables
    select(Period, Type1_ATT  = `Type_1_AE_ATT`) %>%
    filter(!is.na(Type1_ATT)) %>%
    select(Period,Type1_ATT)
  data_typeone_1020
}

# TARGET03: Type_I_21_24
clean_type1_data_2021_24 <- function(Type1_ATT_file_2021_2024){
  
  data_typeone_2124 <- read_csv(Type1_ATT_file_2021_2024,col_types = cols()) %>%
    as_tibble() %>%
    # 1. Rename variables and create date variables
    select(Period, Type1_ATT  = `Type_1_AE_ATT`) %>%
    filter(!is.na(Type1_ATT)) %>%
    select(Period,Type1_ATT)
  data_typeone_2124
}

# TARGET 04: Union all three TYPEI Attendances

union_typeI <- function (data_typeone_10, data_typeone_1020, data_typeone_2124){
  
   file_one  <- data_typeone_10
   file_two  <- data_typeone_1020
   file_three  <- data_typeone_2124
   
# Then we union these three files (this works fine)
Type_I_appended <- bind_rows(file_one  ,file_two, file_three)

write.csv(Type_I_appended,here("objects","Type_I_appended.csv"), row.names = TRUE)

Type_I_appended

 }

# TYPE II

# TARGET 05
clean_type2_data_2010 <- function(Type2_ATT_file_2010){
  
  data_typetwo_10 <- read_csv(Type2_ATT_file_2010,col_types = cols()) %>%
    as_tibble() %>%
    # 1. Rename variables and create date variables
    select(Period, Type2_ATT  = `Type_2_AE_ATT`) %>%
    filter(!is.na(Type2_ATT)) %>%
    select(Period,Type2_ATT)
  data_typetwo_10
}

# TARGET 06
clean_type2_data_2010_20 <- function(Type2_ATT_file_2011_2020){
  
       data_typetwo_1020 <- read_csv(Type2_ATT_file_2011_2020,col_types = cols()) %>%
          as_tibble() %>%
        # 1. Rename variables and create date variables
       select(Period, Type2_ATT  = `Type_2_AE_ATT`) %>%
       filter(!is.na(Type2_ATT)) %>%
       select(Period,Type2_ATT)
     data_typetwo_1020
}

# TARGET 07
 clean_type2_data_2021_24 <- function(Type2_ATT_file_2021_2024){
   
        data_typetwo_2124 <- read_csv(Type2_ATT_file_2021_2024,col_types = cols()) %>%
          as_tibble() %>%
          # 1. Rename variables and create date variables
          select(Period, Type2_ATT  = `Type_2_AE_ATT`) %>%
          filter(!is.na(Type2_ATT)) %>%
          select(Period,Type2_ATT)
        data_typetwo_2124
 }

## UNION ALL TYPE II files
 
# TARGET 08
union_typeII <- function (data_typetwo_10, data_typetwo_1020, data_typetwo_2124){
  
   file_one  <- data_typetwo_10
   file_two  <- data_typetwo_1020
   file_three  <- data_typetwo_2124
   
# Then we union these three files (this works fine)
Type_II_appended <- bind_rows(file_one  ,file_two, file_three)

write.csv(Type_II_appended,here("objects","Type_II_appended.csv"), row.names = TRUE)

Type_II_appended
}

## NEXT TARGET MERGE UNIONED BOTH TYPE I AND TYPE II DATASETS

# TARGET 09
# We merge in a LEFT JOIN both "Type_I_appended" and "Type_II_appended" data sets

# Type_I_appended files:[Period],[Type1_ATT]
# Type_II_appended files:[Period],[Type2_ATT] 

type_I_II_merged <- function(Type_I_appended,Type_II_appended){
  
  type_I_unioned <- Type_I_appended
        type_II_unioned <- Type_II_appended   
          
        merged_I_II_raw <- left_join(type_I_unioned,type_II_unioned,
                                    by = join_by(Period==Period))
        merged_type_files <- merged_I_II_raw
  
  write.csv(merged_type_files,here("objects","Attendances_I_II_merged.csv"),row.names=TRUE)
  merged_type_files
  
  
}


