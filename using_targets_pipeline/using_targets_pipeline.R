# using_targets_pipeline.R

# At this stage we start by loading {targets} to use specific functions 
# to run the pipeline we have just created in the _targets.R file

# 1. Load targets library
library(targets)

# 2. First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)

# 3. Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork()

# 4. Finally we run the pipeline we just built earlier using tar_make() function
tar_make()

# This function runs the correct targets in the correct order and saves the results to files

