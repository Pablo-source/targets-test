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
# Load data set created in the pipeline
tar_read(data_typeone) # Ingested Type I data. Target created “data_typeone” in the pipeline
tar_read(data_typetwo) # Ingested Type II data. Target created “data_typetwo” in the pipeline
tar_read(data_typethree) # Ingested Type III data. Target created “data_typethree” in the pipeline
tar_read(one_two_combined) # combined previous two .csv files
# New object combining all three merged files
tar_read(all_three_files_combined)
# Object ready for plot
tar_read(data_for_plot)


# 2.2 Load objects from targets/objects folder to your environment
tar_load(data)
tar_load(plot)
tar_load(data_ts)
tar_load(one_two_combined)

# 2.3 After modifying any portion of your targets pipeline,
# And saving the study-functions.R file we run "tar_outdated()" to find out 
# which sections of your targets have been modified.
tar_outdated()