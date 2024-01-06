# targets-test
Project to practise all targets package set of functions

## 1. Create single scripts for each analysis steps

- In this example I have started creating one script to load the data and another one to create a plot from that data

## 2. Turn these single scripts into functions

There is a folder called "before targets" containing individual R scripts called "code_pre_targets.R" this script allows me to plan the analysis.
The second script "scripts_into_functions_targets_prep.R" contains new **functions** based on initial scripts to wwork with Targets package

## 3. Functions used by Targets saved in R folder

- see script "study_functions.R" initial scripts for each analysis step turned into functions to be used in targets pipeline

## 3.1 Pipeline defined in the _targets.R file

pipeline
list(
  - 1-3. Read in data
  tar_target(file, "Type_I_AE_Attendances_AUG2010_NOV2023.csv", format = "file"),
  - 2-3. Clean data
  tar_target(data, command = clean_data(file)),
  - 3-3 Plot data 
  tar_target(plot, command = plot_data(data))
)

## 4. Specific {targets} functions used to execute the pipeline 

Load targets library
library(targets)

- First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)

- Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork()

![initial_pipeline_visnetwork](https://github.com/Pablo-source/targets-test/assets/76554081/f3ae16ad-04a8-4af4-8578-8bbb06882ab4)

- Finally we run the pipeline we just built earlier using tar_make() function
tar_make()

## 5. Pipeline has run producing the plot as output

![targets_test_final_pipeline_has_ran](https://github.com/Pablo-source/targets-test/assets/76554081/71f23aaa-11b0-4552-8319-fb1c03a41825)


