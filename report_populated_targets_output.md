Populate Markdown report with Targets pipeline objects
================
PLR
2024-04-16

## Setup

Load required packages first

``` r
# "tibble","tidyverse","here"
library(tibble)
library(tidyverse)
## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.2     ✔ purrr     1.0.2
## ✔ forcats   1.0.0     ✔ readr     2.1.4
## ✔ ggplot2   3.4.3     ✔ stringr   1.5.0
## ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
library(here)
## here() starts at /home/pablo/Documents/Pablo_zorin/Github_Pablo_source_zorin/targets-test
library(targets)
```

## AIM

This Markdown report is populated with the pipeline objects created in
the pipeline file “\_targets.R” and set of functions defined by the R
script ” populate_markdown_with_targets_functions.R”. It shows an small
example on how a Targets pipeline can be used to build a Markdown
report.

As the “\_targets.R” file is unique to each pipeline, I have saved the
“\_targets.R” file to setup and run the pipeline and also to replicate
this specific report in the “Pipeline_01_populate_markdown_with_targets”
folder.

All remaining files used to build and run this report can also be found
in that folder The input data used to create the tables and charts in
this report is also saved in the “data” folder at the project directory
folder level.

## Load Targets functions

We source required Target functions to create the output elements for
this report. This functions are saved in the R sub-folder where Targets
sources all scripts required to run the functions that populate the
pipeline:

``` r
source(here("R","populate_markdown_with_targets_functions.R"))
```

## Run pipeline using targets ad hoc function

The next step is to run
**using_populate_markdown_with_targets_pipeline.R** from at the project
folder directory level we will run the set of commands required to build
and inspect the pipeline:

- library(targets)

Then we source the script in the R folder with functions to populate the
pipeline

- source(“R/populate_markdown_with_targets_functions.R”)

After that, we check for errors in the pipeline using tar_manifest()
function

- tar_manifest(fields = command)

Next, check pipeline dependency graph using tar_visnetwork() function

- tar_visnetwork()

- Finally we run the pipeline we just built earlier using tar_make()
  function. This function runs the correct targets in the correct order
  and saves the results to files

- tar_make()

- Once all the objects from the pipeline have been created, we can Run
  this Markdown report pressing “Run” in the
  report_populated_targets_output.Rmd file and finally, by pressing the
  “knit” button, we will obtain the rendered document, in this instance
  is a github document, but it can also be rendered ad HTML, PDF or Word
  document.

## Data all files combined

We check the final data frame imported from Excel file with AE
Attendances Type I, Type II and Type II data.

``` r
tar_read(clean_ATT_data) 
## # A tibble: 164 × 4
##    date       AE_att_TypeI AE_att_TypeII AE_att_TypeIII
##    <date>            <int>         <int>          <int>
##  1 2010-08-01      1138652         54371         559358
##  2 2010-09-01      1150728         55181         550359
##  3 2010-10-01      1163143         54961         583244
##  4 2010-11-01      1111294         53727         486005
##  5 2010-12-01      1159203         45536         533000
##  6 2011-01-01      1133880         51584         542331
##  7 2011-02-01      1053707         51249         494407
##  8 2011-03-01      1225221         57900         580318
##  9 2011-04-01      1197212         54042         593119
## 10 2011-05-01      1221687         57066         594940
## # ℹ 154 more rows
```

## Type I Accident and Emergency Attendances plot

This section includes the plot for Type I A&E Attendances created in the
pipeline

``` r
tar_read(line_chart_AE_att_TypeI)
```

![](report_populated_targets_output_files/figure-gfm/AE_type_I_plot-1.png)<!-- -->

## Type II Accident and Emergency Attendances

Total number of Type II A&E Attendances from 2011 to March 2024

``` r
tar_read(line_chart_AE_att_TypeII)
```

![](report_populated_targets_output_files/figure-gfm/AE_type_II_plot-1.png)<!-- -->

## Type III Accident and Emergency Attendances

Total number of Type III A&E Attendances from 2011 to March 2024

``` r
tar_read(line_chart_AE_att_TypeIII)
```

![](report_populated_targets_output_files/figure-gfm/AE_type_III_plot-1.png)<!-- -->
