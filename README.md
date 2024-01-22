# targets-test
Project to practise creating analytical pipelines to run models using {targets} library. 

- The {targets} R package user manual:  <https://books.ropensci.org/targets/>
- Targets walkthrough: <https://books.ropensci.org/targets/walkthrough.html>

## Quick start using Targets
After installing the package, we load targets “library(targets)”. Then our first step is to run “**use_tergets()**” function. This **creates** a new file called **_tragets.R** that is used to **configure** and **setup** the **pipeline**.

Follow these steps then detailed in the R Documentation section of the use_targets() function: 

After you call use_targets(), there is still configuration left to do:

Open ⁠_targets.R⁠ and edit by hand. Follow the comments to write any options, packages, and target definitions that your pipeline requires.

Edit run.R and choose which pipeline function to execute (tar_make(), tar_make_clustermq(), or tar_make_future()).

If applicable, edit clustermq.tmpl and/or future.tmpl to configure settings for your resource manager.

If applicable, configure job.sh, "clustermq.tmpl", and/or "future.tmpl" for your resource manager.

## 1. Create single scripts for each analysis steps

- In this example I have started creating one script to load the data and another one to create a plot from that data

- See script: before_targets/**code_pre_targets.R**

## 2. Turn these single scripts into functions

There is a folder called "before targets" containing individual R scripts called "code_pre_targets.R" this script allows me to plan the analysis.
The second script "scripts_into_functions_targets_prep.R" contains new **functions** based on initial scripts to wwork with Targets package

- See script: before_targets/**scripts_to_functions.R**

## 3. Functions used by Targets saved in R folder

- The set of functions we want to run as part of our pipeline, are saved in the **R folder** for Targets to use them when executing the pipeline

- see script "study_functions.R" initial scripts for each analysis step turned into functions to be used in targets pipeline

- See script: R/**study_functions.R**

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

![targets_visnetwork_save_plot](https://github.com/Pablo-source/targets-test/assets/76554081/315973d4-0081-436e-bc0c-ce38d7762831)

## 4. Specific {targets} functions used to execute the pipeline 

Load targets library
library(targets)

- First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)

- Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork()

![save_my_plot_visnetwork](https://github.com/Pablo-source/targets-test/assets/76554081/dc3851c6-1a73-4582-bc5c-468b0eec1ab7)

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
And also It will be included as a new section in the new rendered Markdown report as a final output from the pipeline. The script containing new targets functions for both ARIMA and TBATS univariate TS model is called **scripts_to_functions_forecast.R**
