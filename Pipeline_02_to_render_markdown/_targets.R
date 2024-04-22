# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # This package is requierd to render Markdown report from pipeline

# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  # Packages that your targets need for their tasks.
  packages = c("tibble","janitor","tidyverse","here","readxl","viridis","hrbrthemes")
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  # Pipelines that take a long time to run may benefit from
  # optional distributed computing. To use this capability
  # in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller that scales up to a maximum of two workers
  # which run as local R processes. Each worker launches when there is work
  # to do and exits if 60 seconds pass with no tasks to run.
  #
  #   controller = crew::crew_controller_local(workers = 2, seconds_idle = 60)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package.
  # For the cloud, see plugin packages like {crew.aws.batch}.
  # The following example is a controller for Sun Grid Engine (SGE).
  # 
  #   controller = crew.cluster::crew_controller_sge(
  #     # Number of workers that the pipeline can scale up to:
  #     workers = 10,
  #     # It is recommended to set an idle time so workers can shut themselves
  #     # down if they are not running tasks.
  #     seconds_idle = 120,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.2".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source("R/pipeline_render_markdown_functions.R")
# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
# Input file "Monthly-AE-Time-Series-March-2024.xls"
list(
  tar_target(AE_data_input,here("data","Monthly-AE-Time-Series-March-2024.xls"),format = "file"),
  # 1. Clean input files
  tar_target(clean_ATT_data, command = clean_ATT_data_function(AE_data_input)),
  # 2. Pivot data for chart
  tar_target(AE_data_long, command = pivot_data(clean_ATT_data)),
  # 3. Create plot for report
  tar_target(area_chart, command = plot_data(AE_data_long)),
  # 4. NEW targets to RENDER report from PIPELINE
  tar_render(render_report,"AE_Attendances_report_rendered_in_pipeline.Rmd")
)
