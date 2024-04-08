# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("tibble","janitor","tidyverse","here","stats","forecast") # packages that your targets need to run
)

options(clustermq.scheduler = "multicore")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source("R/dynamic_pipeline_functions.R")
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
 tar_target(grouped_by_mertic,grouped_metric, pattern =map(grouped_metric))
 
)

  
