# Script:using_union_merge_pipeline.R
# Set of targets functions to explore output from "union_merge_pipeline"
# Functions stored in \R folder to run this pipeline "union_merge_functions.R"
# 1. BUILDING THE PIPELINE
# 1.1 Load targets library
library(targets)

# 1.2 First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)
# 1.3 Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork()
# 1.4 Finaly we run the pipeline we just built earlier using tar_make() function
# This function runs the correct targets in the correct order and saves the results to files
tar_make()

# 2. EXPLORING PIPELINE OBJECTS CREATED
# 2.1 Accessing objects created by Targets pipeline
# Inside _targets folder, we can access different access created saved in the object folder
# Load data set created in the pipeline
tar_read(data_typeone_10) # Ingested Type I data. 
tar_read(data_typeone_1020) # Ingested Type II data.
tar_read(data_typeone_2124)
tar_read(One_two_three)
# Read and Load output target from TypeI unioned files
tar_read(Type_I_appended)
tar_load(Type_I_appended)
# Read and Load output dataset from TypeI unioned files
tar_read(Type_II_appended)
tar_load(Type_II_appended)

# 3. Force targets to remove some targets so next time we run tar_make() all pipeline will be re-build
# List of targets to invalidate:(data_typeone,data_typetwo,data_typethree,one_two_combined,one_two_three_combined)
# These target objects produce .csv output files [one_two_combined,one_two_three_combined]
#   write.csv(one_two_combined,here("objects","one_two_combined.csv"), row.names = TRUE)
#  write.csv(one_two_three_combined,here("objects","one_two_three_combined.csv"), row.names = TRUE)
tar_invalidate(Type_I_appended)
tar_invalidate(Type_II_appended) 
tar_invalidate(One_two_three) 

# then run tar_make() again - TO ENSURE .CSV output files always are created when we run the pipeline
tar_make()

# 4. Load objects from targets/objects folder to your environment
tar_load(merged_type_files)

# 4.1 After modifying any portion of your targets pipeline,
# And saving the study-functions.R file we run "tar_outdated()" to find out 
# which sections of your targets have been modified.
tar_outdated()