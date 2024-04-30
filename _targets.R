# Created by use_targets().
# Project: DYNAMIC_BR_MODELS.Rproj
# Path: C:\R\WorkingDir\Targets_tutorial_MY_NOTES\10_TARGETS_include_MODELS\DYNAMIC_BR_MODELS

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load library {tarchetypes} to implement dynamic branching
# https://github.com/ropensci/tarchetypes

library(tidyverse)   # LOad tidyverse to allow initial_time_split() function to work
# Or include "tidymodels" in the tar_option_set() function to load required
# packages for the pipeline
library(rsample)     # Package required to perform train/test split

library(modeltime) # Load ARIMA and PROPHET models from {modeltime} package 
# ARIMA model: arima_reg()

library(parsnip)                   # We require PARSNIT package to use set_engine() function

# Set target options:
tar_option_set(
  packages = c("tibble","janitor","tidyverse","here","stats","forecast","rsample") # packages that your targets need to run
)
options(clustermq.scheduler = "multicore")

# Run the R scripts in the R/ folder with your custom functions:
# Pipeline including predictive models: "dynamic_predictive_pipeline_functions.R"

tar_source("R/dynamic_predictive_pipeline_functions.R")

# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:

list(
  tar_target(Computer_data_input,here("data","A34SVS_Shipments_value_Computer_products.csv"),format = "file"),
  tar_target(Durable_goods_input,here("data","AMDMVS_Shipments_value_Durable_goods.csv"),format = "file"),
  tar_target(Total_manuf_input,here("data","AMTMVS_Shipments_Total_Manufacturing.csv"),format = "file"),
  # 1. Clean input files
  tar_target(computer_data, command = clean_computer_data(Computer_data_input)),
  tar_target(durable_goods, command = clean_durable_goods_data(Durable_goods_input)),
  tar_target(computer_durable, command = union_computer_durable(computer_data,durable_goods)),
  # 2. Introduce branching using "tar_group_by()" function from {tarchetypes} package
  # Create different branches by Metric variable (we will apply one model at a time to each individual branch)
  tar_group_by(grouped_metric, computer_durable, Metric),
  tar_target(grouped_by_metric,grouped_metric, pattern =map(grouped_metric)),
  # Include TRAIN TEST SPLIT
  # TRAIN set
  tar_target(train_data, command = test_train_split(grouped_by_metric)),
  # TEST set
  tar_target(test_data, command = test_train_split(grouped_by_metric)),
  # Include ARIMA model
  tar_target(model_fit_arima, command = ARIMA_model(train_data)),
  # Include Prophet model
  tar_target(model_fit_prophet, command = PROPHET_model(train_data))
)

  
