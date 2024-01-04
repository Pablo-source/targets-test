# code_pre_targets.R

# Initial analysis used to generate a report that we will turn into a pipeline.
# This first file is the entire analysis into a single script
# we will turn it into functions to be used within {targets} library

# It is considered good practise to test the entire report script before building the pipeline,
# to check the input and outputs work as expected

library(tidyverse)
library(here)

# 1. Read data
# we use read_csv() function from {readr} package included in {tidyverse}
# read_csv() creates a tibble

here_i_am <- here::here()
here_i_am

list.files("data/",".csv")