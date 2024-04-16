# Created by use_targets().
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# PIPELINE: "Pipeline_01_populate_markdown with targets" 

# This _targets.R file is part of the "Pipeline_01_populate_markdown with targets" pipeline
# _target.R is the pipeline creation and configuration file. 
# The required set of functions to run this pipeline script in the \R file is: 
# R Script: populate_markdown_with_targets_functions.R

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load library {tarchetypes} to implement dynamic branching
                     # https://github.com/ropensci/tarchetypes

# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("tibble","janitor","tidyverse","here","readxl") # packages that your targets need to run
)

options(clustermq.scheduler = "multicore")

# Run the R scripts in the R/ folder with your custom functions:
# For this specific pipeline: "populate_markdown_with_targets_functions.R"
tar_source("R/populate_markdown_with_targets_functions.R")
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:

list(
  tar_target(AE_data_input,here("data","Monthly-AE-Time-Series-March-2024.xls"),format = "file"),
  # 1. Clean input files
  tar_target(clean_ATT_data, command = clean_ATT_data_function(AE_data_input)),
  # 2. Get Type I Attendances data
  tar_target(ATT_Type_I, command = ATT_Type_I_clean_function(clean_ATT_data)),
  # 3. Get Type II Attendances data
  tar_target(ATT_Type_II, command = ATT_Type_II_clean_function(clean_ATT_data)),
  # 4. Get Type III Attendances data
  tar_target(ATT_Type_III, command = ATT_Type_III_clean_function(clean_ATT_data)),
  # 5. Plot AE_att_TypeI
  tar_target(line_chart_AE_att_TypeI, command = type_1_plot(clean_ATT_data)),
  # 6.Plot AE_att_TypeII
  tar_target(line_chart_AE_att_TypeII, command = type_2_plot(clean_ATT_data)),
  # 7. Plot AE_att_TypeIII
  tar_target(line_chart_AE_att_TypeIII, command = type_3_plot(clean_ATT_data))
)

  
