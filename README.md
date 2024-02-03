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
  - 1-4 Read in data
  tar_target(file, "Type_I_AE_Attendances_AUG2010_NOV2023.csv", format = "file"),
  **input .csv file saved in the /data sub-folder, targets will load it to initiate the first pipeline stage**
  - 2-4 Clean data
  tar_target(data, command = clean_data(file)),
  - 3-4 Plot data 
  tar_target(plot, command = plot_data(data)),
  - 4.4 Save plot
  tar_target(savemyplot, command = save_plot(data))
)

![Modified_pipeline_get_data_from_sub_folder](https://github.com/Pablo-source/targets-test/assets/76554081/ad41634f-0bf6-426f-a0aa-4759666595eb)

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

## 5. Modify plot_data target to save plot as .png file

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

## 6. Run pipeline

Fnally we run the pipeline we just built earlier using tar_make() function
This function runs the correct targets in the correct order and saves the results to files
**tar_make()**

![image](https://github.com/Pablo-source/targets-test/assets/76554081/3ec037ac-6ab9-4a0a-adac-8515cef7a585)

## 7. Render Markdown report from Pipeline objects created in previous step

Everytime we update something in the pipeline we use "tar_make()" to re-run the entire pipeline. If some of the targets have not changed since last time we ran the pipeline, targets will skip those nodes in the pipeline called targets.

The **tar_read()** function we collect the pipeline output object to be used in specific sections of the Markdown report. For example, to use the data frame we creaetd on the first target we use **tar_read(data)**. To use in the Markdown report the plot we created in the second Target object we use **tar_read(plot)**. This allows us to populate our markdown report with specific objects created alongside the pipeline we just built and ran.

The final output of this pipeline is being used to create a fully rendered markdown report produced by the markdown file **report.Rmd** has been created and published in this repo:
![Markdown_report_output](https://github.com/Pablo-source/targets-test/assets/76554081/196a9c12-938c-4757-bc11-33e74089a355)

The last step of this project has been building and rendering a markdown report called **report.Rmd** populated with the objects created in the pipeline by Targets. The aim is to autonmate the reports creation tasks by running a pipeline making it easier to mantain and update this report in the future.
When rendering **report.Rmd** we obtain a document populated with tables and content from the pipeline. This could be expanded to automate reports ensuring reproducibility. Trying to follow **RAP** principles.

So now we have an initial pipeline that we can start to modify and expand to include extra analytical steps in the form of new targets 

![rendered_markdown_report_from_targets_pipeline](https://github.com/Pablo-source/targets-test/assets/76554081/302f7f6b-41ad-4c41-9fd8-c65908aa7aa9)


## 8.Adding univariate TS model forecast using TBTAS and ARIMA

Using {forecast} package I include two univariate TS models ARIMA and TBATS to forecast the nect 24 monhts of data. This Forecast model is going to be a new Targets in the pipeline.
And also It will be included as a new section in the new rendered Markdown report as a final output from the pipeline. The script containing new targets functions for both ARIMA and TBATS univariate TS model is called **scripts_to_functions_forecast.R**

First I will start preparing the data to work with TS objects to be used with {forecast} package to apply ARIMA and TBATS models
Created new targets object in the pipeline based on a function called **fcast_data_prep()**
![image](https://github.com/Pablo-source/targets-test/assets/76554081/be8ad144-c8b8-49ef-94ae-6fde241cae9a)

And this is the visnetwork diagram including the new data preparation target in the pipeline:
****![image](https://github.com/Pablo-source/targets-test/assets/76554081/fb3e93d1-88a3-49d1-af6e-b987aac712ea)
![image](https://github.com/Pablo-source/targets-test/assets/76554081/12c45729-deeb-4c1e-8b55-5b98f438b30b)

