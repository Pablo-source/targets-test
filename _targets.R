# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("tibble","tidyverse","here","stats","forecast") # packages that your targets need to run
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller with 2 workers which will run as local R processes:
)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multicore")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source("R/study_functions.R")
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
# pipeline
list(
  # Read in any pipeline input data from new "data" sub-folder
  # 1. DATA INGESTION
  # Ingest three AE data  .csv files downloaded from NHSE website
  tar_target(Type1_ATT_file,here("data","AE_TYPE_1_ATT_AUG10_JAN24.csv"),format = "file"),
  tar_target(Type2_ATT_file,here("data","AE_TYPE_2_ATT_AUG10_JAN24.csv"),format = "file"),
  tar_target(Type3_ATT_file,here("data","AE_TYPE_3_ATT_AUG10_JAN24.csv"),format = "file"),
  # 2. MERGE FILES
  # Pipeline section clean AE data prior to merge them
  tar_target(data_typeone, command = clean_type1_data(Type1_ATT_file)),
  tar_target(data_typetwo, command = clean_type2_data(Type2_ATT_file)),
  tar_target(data_typethree, command = clean_type3_data(Type3_ATT_file)),
  # Merge previous three cleansed files
  # Merge Type1 with Type2 att files
  tar_target(one_two_combined, command = merge_files(data_typeone,data_typetwo)),
  # Merge last file Type3 with previous two ones
  tar_target(all_three_files_combined, command = merge_all_files(one_two_combined,data_typethree)),
  # 3. PLOT DATA 
  # 3.1 Data prep for plot
  tar_target(data_for_plot, command = format_data_plots(all_three_files_combined)),
  # 3.2 save plot as .png object
  tar_target(line_chart,command = type_1_plot(data_for_plot)),
  # 3.3 Create plot for report (to be called from Target function in report)
  tar_target(plot_1_report,command = type_1_plot_report(data_for_plot)),
  tar_target(plot_2_report,command = type_2_plot_report(data_for_plot)),
  tar_target(plot_3_report,command = type_3_plot_report(data_for_plot))
  
  # 4 Data prep for ARIMA and TBATS forecasting models (WIP)

)
