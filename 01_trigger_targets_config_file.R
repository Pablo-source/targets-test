# How to Trigger _targets.R package configuration

# 1. Go to the Console pane and load targets library by typing “library(targets)”
> library(targets)
#  Warning message:
#  package ‘targets’ was built under R version 4.3.2 

library(targets)

# 2. Run tar_edit() to start a new targets project
# Go to the Console pane and type “tar_edit()”
tar_edit()

# This tar_edit() function will create a new _targets.R file and also will open it so we can custom it