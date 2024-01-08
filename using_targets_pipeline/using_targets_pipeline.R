# using_targets_pipeline.R

# At this stage we start by loading {targets} to use specific functions 
# to run the pipeline we have just created in the _targets.R file

# 1. BUILDING THE PIPELINE

# 1.1 Load targets library
library(targets)

source("R/study_functions.R")
# 1.2 First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)

# 1.3 Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork()

# 1.4 Finally we run the pipeline we just built earlier using tar_make() function
# This function runs the correct targets in the correct order and saves the results to files
tar_make()

# 2. EXPLORING PIPELINE OBJECTS CREATED
# 2.1 Accessing objects created by Targets pipeline
# Inside _targets folder, we can access different access created saved in the object folder
tar_read(data)

# 2.2 Load objects from targets/objects folder to your environment
tar_load(data)
