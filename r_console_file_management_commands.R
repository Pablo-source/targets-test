# R console files management commands 
list.files()
# 1. Create new "data" folder
if(!dir.exists("data")){dir.create("data")}
# 2. Check for the .csv file or .xlsx files I need to move into the newly created data folder 
Excel_files <- Sys.glob("*.xlsx")
Excel_files
CSV_files <- Sys.glob("*.csv")
CSV_files

# [1] "Type_I_AE_Attendances_AUG2010_NOV2023.csv"

# 3. Move  "Type_I_AE_Attendances_AUG2010_NOV2023.csv" .csv file inside 
# newly created "data" sub-folder using filesstrings library
# Using file.move() function from {filesstrings}
library(filesstrings)

here()
file.move("/home/pablo/Documents/Pablo_zorin/Github_Pablo_source_zorin/targets-test/Type_I_AE_Attendances_AUG2010_NOV2023.csv", 
          "/home/pablo/Documents/Pablo_zorin/Github_Pablo_source_zorin/targets-test/data")