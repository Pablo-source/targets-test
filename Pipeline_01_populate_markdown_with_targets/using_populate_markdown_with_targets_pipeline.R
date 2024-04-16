# using_populate_markdown_with_targets_pipeline.R

# 1. BUILDING THE PIPELINE

# 1.1 Load targets library
library(targets)
# Source script in R folder to load required functions to build pipeline
source("R/populate_markdown_with_targets_functions.R")
# 1.2 First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)
# 1.3 Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork()
tar_visnetwork(label="branches")
# 1.4 Finaly we run the pipeline we just built earlier using tar_make() function
# This function runs the correct targets in the correct order and saves the results to files
tar_make()

# 2. EXPLORING PIPELINE OBJECTS CREATED
# 2.1 Accessing objects created by Targets pipeline
# Inside _targets folder, we can access different access created saved in the object folder
# Load data set created in the pipeline
tar_read(clean_ATT_data) # Ingested Type I data. Target created “data_typeone” in the pipeline


# 2.2 Load objects from targets/objects folder to your environment
tar_load(clean_ATT_data)

# 2.3 After modifying any portion of your targets pipeline,
# And saving the study-functions.R file we run "tar_outdated()" to find out 
# which sections of your targets have been modified.
tar_outdated()