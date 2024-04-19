# Created by use_targets().
# R script: _targets.R
# It must be ran from \WorkingDir folder to work properly on work laptop.

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(packages = c("tibble","tidyverse","here","stats","forecast"))
# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multicore")
# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
# Script for this specific pipline: union_merge_functions.R
tar_source("R/union_merge_functions.R")
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
# pipeline
list(
  # Read in data from new "data" sub-folder in the pipeline
  # 1.DATA INGESTION
  tar_target(Type1_ATT_file_2010,here("data","AE_TYPE_1_ATT_AUG10_JAN24_2010.csv"), format = "file"),
  tar_target(Type1_ATT_file_2011_2020,here("data","AE_TYPE_1_ATT_AUG10_JAN24_2011_2020.csv"), format = "file"),
  tar_target(Type1_ATT_file_2021_2024,here("data","AE_TYPE_1_ATT_AUG10_JAN24_2021_2024.csv"), format = "file"),
  
  tar_target(Type2_ATT_file_2010,here("data","AE_TYPE_2_ATT_AUG10_JAN24_2010.csv"), format = "file"),
  tar_target(Type2_ATT_file_2011_2020,here("data","AE_TYPE_2_ATT_AUG10_JAN24_2011_2020.csv"), format = "file"),
  tar_target(Type2_ATT_file_2021_2024,here("data","AE_TYPE_2_ATT_AUG10_JAN24_2021_2024.csv"), format = "file"),
  
  # 1.1 Clean files
    # Pipeline section clean AE data prior to merging files
  tar_target(data_typeone_10,   command = clean_type1_data_2010(Type1_ATT_file_2010)),
  tar_target(data_typeone_1020, command = clean_type1_data_2010_20(Type1_ATT_file_2011_2020)),
  tar_target(data_typeone_2124, command = clean_type1_data_2021_24(Type1_ATT_file_2021_2024)),
 
  tar_target(data_typetwo_10,   command = clean_type2_data_2010(Type2_ATT_file_2010)),
  tar_target(data_typetwo_1020, command = clean_type2_data_2010_20(Type2_ATT_file_2011_2020)),
  tar_target(data_typetwo_2124, command = clean_type2_data_2021_24(Type2_ATT_file_2021_2024)),
 
# 2. UNION FILES
  tar_target(Type_I_appended, command = union_typeI(data_typeone_10, data_typeone_1020, data_typeone_2124)),
  tar_target(Type_II_appended, command = union_typeII(data_typetwo_10, data_typetwo_1020, data_typetwo_2124)),
# 3. MERGE UNIONED FILES
  # Pipeline section where we merge previously unioned files
  tar_target(merged_type_files, command = type_I_II_merged(Type_I_appended,Type_II_appended))
  )
