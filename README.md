# targets-test
Project to practise all targets package set of functions

## 1. Create single scripts for each analysis steps

- In this example I have started creating one script to load the data and another one to create a plot from that data

## 2. Turn these single scripts into functions

There is a folder called "before targets" containing individual R scripts called "code_pre_targets.R" this script allows me to plan the analysis.
The second script "scripts_into_functions_targets_prep.R" contains new **functions** based on initial scripts to wwork with Targets package

## 3. Functions used by Targets saved in R folder

- The set of functions we want to run as part of our pipeline, are saved in the R folder for Targets to use them when executing the pipeline

- see script "study_functions.R" initial scripts for each analysis step turned into functions to be used in targets pipeline

## 3.1 Pipeline defined in the _targets.R file

pipeline
list(
  - 1-3. Read in data
  tar_target(file, "Type_I_AE_Attendances_AUG2010_NOV2023.csv", format = "file"),
  **input .csv file saved at the project folder level, targets will load it to initiate the first pipeline stage**

  - 2-3. Clean data
  tar_target(data, command = clean_data(file)),
  - 3-3 Plot data 
  tar_target(plot, command = plot_data(data))
)

![Pipeline_defined_targts_file](https://github.com/Pablo-source/targets-test/assets/76554081/b6f17784-decf-48af-8f7a-33802785837b)


## 4. Specific {targets} functions used to execute the pipeline 

Load targets library
library(targets)

- First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)

- Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork()

![Final_pipeline_2024_09_18H](https://github.com/Pablo-source/targets-test/assets/76554081/07cb23bd-d1c7-4cf0-bbaa-868939d38fa0)

- Finally we run the pipeline we just built earlier using tar_make() function
tar_make()

## 5. Pipeline has run  using Targets objects producing the markdown report as final output

Everytime we update something in the pipeline we use "tar_make()" to re-run the entire pipeline. If some of the targets have not changed since last time we ran the pipeline, targets will skip those nodes in the pipeline called targets.

The final output of this pipeline is a fully rendered markdown report produced by the markdown file **report.Rmd** has been created and published in this repo:
![Markdown_report_output](https://github.com/Pablo-source/targets-test/assets/76554081/196a9c12-938c-4757-bc11-33e74089a355)


So now we have an initial pipeline that we can start to modify and expand to include extra analytical steps in the form of new targets

![targets_test_final_pipeline_has_ran](https://github.com/Pablo-source/targets-test/assets/76554081/71f23aaa-11b0-4552-8319-fb1c03a41825)

## 6. Modify plot_data target to save plot as .png file

Finally, we can start saving all pipeline outputs (as the "line_chart.png" file we just created) in a new **"objects"** folder, by modifying the plot_data function we created earlier
![targets_plot_output_file](https://github.com/Pablo-source/targets-test/assets/76554081/76bc4faa-e591-4e55-ac77-c31849ce5fd5)

plot_data <- function(data){
    
line_chart <-    ggplot(data) +
    geom_line(aes(x =Datef, y = Att_TypeI)) +
    labs(title = "A&E Type I Attendances. 2011-2023 period",
         subtitle = "Type I A&E Attendances by month",
         x = "Period", y = "Type I Attendances" ) 
  
  path_out <- here::here("objects","line_chart.png")
  ggsave(path_out,line_chart)
 
}

The plot created from our pipeline is now saved as an individual .png chart

![line_chart](https://github.com/Pablo-source/targets-test/assets/76554081/a8ea187c-d87d-46a9-93e1-1c65d00ece06)

## 7. Expanding initial Markdown report using targets objects 

The last step of this project has been building and rendering a markdown report called **report.Rmd** populated with the objects created in the pipeline by Targets. The aim is to autonmate the reports creation tasks by running a pipeline making it easier to mantain and update this report in the future.
When rendering **report.Rmd** we obtain a document populated with tables and content from the pipeline. This could be expanded to automate reports ensuring reproducibility. Trying to follow **RAP** principles.

### 7.1 Adding an univariate TS model forecast using TBTAS and ARIMA

Using {forecast} package I include two univariate TS models ARIMA and TBATS to forecast the nect 24 monhts of data. This Forecast model is going to be a new Targets in the pipeline.
And also It will be included as a new section in the new rendered Markdown report as a final output from the pipeline
