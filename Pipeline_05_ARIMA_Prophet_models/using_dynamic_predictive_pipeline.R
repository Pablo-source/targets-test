# using_dynamic_predictive_pipeline.R 
#
# Pipeline Name: DYNAMIC PREDICTIVE PIPELINE 
#
# This set of functions to run the pipeline are designed to be executed with these scripts: 
#
# 1). adhoc functions used to setup this specific pipeline: R/dynamnic_pipeline_functions.R
# 2). Specific "_targets.R" file designed for this "dynamic branching" pipeline. (This file can't change name
#     for each pipeline, must remain _targets.R for all of them. We use specific _targets.R file versions to build 
#     each adhoc pipeline)

# 1. BUILDING DYNAMIC PIPELINE

# 1.1 Load targets library
library(targets)
# Source script in R folder to load required functions to build pipeline
# Specific script for this pipeline "dynamnic_pipeline_functions.R" saved in \R sub-folder
source("R/dynamic_predictive_pipeline_functions.R")

# 1.2 Run set of {targets} functions to build an execute this DYNAMIC PIPELINE
# 1.2.1 First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)
# 1.2.2 Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork(label="branches") # For this pipeline including branches I add label = "Branches"
# 1.2.3 Final step: We run the pipeline we just built earlier using tar_make() function
# This function runs the correct targets in the correct order and saves the results to files
tar_make()

# 2. EXPLORING PIPELINE OBJECTS CREATED
# 2.1 Accessing objects created by Targets pipeline
# Inside _targets folder, we can access different access created saved in the object folder
# Load data set created in the pipeline
# List of all objects created in the pipeline: 
# () 
tar_read(Computer_data_input) # Ingested computer goods file
tar_read(Durable_goods_input) # Ingested durable goods file
tar_read(Total_manuf_input) # Ingested Type III data. Target created “data_typethree” in the pipeline
# New object combining all three merged files
tar_read(computer_data)
tar_read(durable_goods)
tar_read(computer_durable)
tar_read(grouped_metric)
tar_read(grouped_by_mertic)  # This targets displayes two branches defined by Metric

# First branch by branch name and HASH assigned by pipeline
tar_read(grouped_by_metric_e0ff7925) # Check content of the first branch created
tar_read(grouped_by_metric_e1b30670) # Check content of the Second branch created

# 2.2 Load objects from targets/objects folder to your environment
tar_load(computer_durable)
tar_load(plot)

# 2.3 After modifying any portion of your targets pipeline,
# And saving the study-functions.R file we run "tar_outdated()" to find out 
# which sections of your targets have been modified.
tar_outdated()