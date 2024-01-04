# Trigger _targets.R package configuration file
# 01_trigger_targets_config_file.R

# 1. Go to the Console pane 

# 2. load targets library by typing “library(targets)”
library(targets)

#  Warning message:
#  package ‘targets’ was built under R version 4.3.2 

# 2. Run use_targets() function to trigger the _targets.R file
use_targets()

# 3. Run tar_edit() to start a new targets project
# Go to the Console pane and type “tar_edit()”
# tar_edit(): Open the target scrip file for editing.
tar_edit()
