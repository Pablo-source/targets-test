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
  #
  #   controller = crew::crew_controller_local(workers = 2)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package. The following
  # example is a controller for Sun Grid Engine (SGE).
  # 
  #   controller = crew.cluster::crew_controller_sge(
  #     workers = 50,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.0".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
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
  # 1 Read in any pipeline input data from new "data" sub-folder
  # Created new first target to read data from /data sub-folder, this first target is called "file_csv"
  # In preparation for future file types such as _xlsx for example.
  tar_target(file_csv,here("data","Type_I_AE_Attendances_AUG2010_NOV2023.csv"), format = "file"),
  # 2 Clean data
  tar_target(data, command = clean_data(file_csv)),
  # 3 Plot data 
  tar_target(plot, command = plot_data(data)),
  # 4 save plot
  tar_target(savemyplot, command = save_plot(data)),
  # 5 Data prep for ARIMA and TBATS forecasting models
  tar_target(data_prep_models, command = fcast_data_prep(data))
)
