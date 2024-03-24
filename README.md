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
![2024-03-24_18-17_study_function_scripts_updated](https://github.com/Pablo-source/targets-test/assets/76554081/0b824425-8582-474a-980a-42ad87415ece)


## 3.1 Pipeline defined in the _targets.R file

pipeline
  - 1-4 Read in data
  - 2-4 Clean data
  - 3-4 Merge files
  - 3-4 Plot data 
)

![2024-03-24_18-14_final_pipeline_merge_plot_files](https://github.com/Pablo-source/targets-test/assets/76554081/8c953784-fd65-4f91-9299-91d9d5711f81)

## 4. Specific {targets} functions used to execute the pipeline 

Load targets library
library(targets)

- First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)

- Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork()

- Finally we run the pipeline we just built earlier using tar_make() function
tar_make()

![Pipeline_functions](https://github.com/Pablo-source/targets-test/assets/76554081/41658ab8-959b-4eff-9007-f4ab76ea6f63)

The plot created from our pipeline is now saved as an individual .png chart

## 5. Run pipeline

Fnally we run the pipeline we just built earlier using tar_make() function
This function runs the correct targets in the correct order and saves the results to files
**tar_make()**

![05_Pipeline_completed_merged_files](https://github.com/Pablo-source/targets-test/assets/76554081/a4c488bf-92ac-49f8-825e-970fad4fc6e2)

## 6. Render Markdown report from Pipeline objects created in previous step

Everytime we update something in the pipeline we use "tar_make()" to re-run the entire pipeline. If some of the targets have not changed since last time we ran the pipeline, targets will skip those nodes in the pipeline called targets.

The **tar_read()** function we collect the pipeline output object to be used in specific sections of the Markdown report. For example, to use the data frame we creaetd on the first target we use **tar_read(data)**. To use in the Markdown report the plot we created in the second Target object we use **tar_read(plot)**. This allows us to populate our markdown report with specific objects created alongside the pipeline we just built and ran.

The final output of this pipeline is being used to create a fully rendered markdown report produced by the markdown file **report.Rmd** has been created and published in this repo:
![Markdown_report_output](https://github.com/Pablo-source/targets-test/assets/76554081/196a9c12-938c-4757-bc11-33e74089a355)

The last step of this project has been building and rendering a markdown report called **report.Rmd** populated with the objects created in the pipeline by Targets. The aim is to autonmate the reports creation tasks by running a pipeline making it easier to mantain and update this report in the future.
When rendering **report.Rmd** we obtain a document populated with tables and content from the pipeline. This could be expanded to automate reports ensuring reproducibility. Trying to follow **RAP** principles.

So now we have an initial pipeline that we can start to modify and expand to include extra analytical steps in the form of new targets 

![rendered_markdown_report_from_targets_pipeline](https://github.com/Pablo-source/targets-test/assets/76554081/302f7f6b-41ad-4c41-9fd8-c65908aa7aa9)


## 7.Adding univariate TS model forecast and merging input files

First we will merge all incoming .csv files 
![06_pipeline_visnetwork_merge_files_section](https://github.com/Pablo-source/targets-test/assets/76554081/574eaba3-8cd6-4a1f-ae55-5e2bc59fe028)

As part of the data preparation stage for future modelling pipeline

![02_Tar_visnetwork_load_csv_ARIMA](https://github.com/Pablo-source/targets-test/assets/76554081/1700eabd-2b73-4e99-88c7-e1af44218bef)

Using {forecast} package I include two univariate TS models ARIMA and TBATS to forecast the nect 24 monhts of data. This Forecast model is going to be a new Targets in the pipeline.
And also It will be included as a new section in the new rendered Markdown report as a final output from the pipeline. The script containing new targets functions for both ARIMA and TBATS univariate TS model is called **scripts_to_functions_forecast.R**

First I will start preparing the data to work with TS objects to be used with {forecast} package to apply ARIMA and TBATS models
Created new targets object in the pipeline based on a function called **fcast_data_prep()**
![image](https://github.com/Pablo-source/targets-test/assets/76554081/be8ad144-c8b8-49ef-94ae-6fde241cae9a)

And this is the visnetwork diagram including the new ARIMA model target as the latest object added to the pipeline:

![04_Tar_visnetwork_ARIMA_model_section](https://github.com/Pablo-source/targets-test/assets/76554081/6b60128a-ce9a-42df-969f-cfa6873d1bfb)

## 8. Pipeline run output

This is the output of the complated pipeline run, with dataframes saved and required .csv files saved in the \objects folder
![05_Pipeline_completed_merged_files](https://github.com/Pablo-source/targets-test/assets/76554081/07cc3ba1-dfc9-4a36-b417-d90d72dc4935)


## 9.Adding univariate TS model forecast

Once the pipeline has run, before we implement a new feature (including a simple ARIMA model) defined in issue '#6', I have run 'fs:dir_tree("targets-test")' to check the list of objects created by Targets after running the pipeline. The Markdown report has been populated by the pipeline objects.

![dir_tree_targets_test_ARIMA_model](https://github.com/Pablo-source/targets-test/assets/76554081/afe91093-42d9-4368-bb59-60150ba645c3)

