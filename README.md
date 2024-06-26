# targets-test
Project to practise creating analytical pipelines to run models using {targets} library. 

- The {targets} R package user manual:  <https://books.ropensci.org/targets/>
- Targets walkthrough: <https://books.ropensci.org/targets/walkthrough.html>

**Important**: 

- Each pipeline has its **unique "_targets.R" file**. And each pipeline will contain specific set of *tar_target()* and *tar_group_by()* functions used to configure the pipeline structure for each project.

- As this *_targets.R* file must retain its original name, I will save each *_targets.R* file for each pipeline in a separate folder in this GitHub project.

- **Each pipeline folder** will have to be run on a dedicated and **individual R project** to match the targets list from **_targets.R** file for that pipeline with its related set of **adhoc R functions** stored in the \R folder

- This will ensure each pipeline works for the purpose stated in the pipeline folder created at the top of this project.

- So when downloading each pipeline folder, it will contain the "_targets.R" files and related functions saved in the \R folder. All required input files will be sourced from the \data folder 

Pipeline_01_populate_markdown_with_targets files:
  - _targets.R                                  (Specific Pipeline setup file)
  - populate_markdown_with_targets_functions.R  (Specific functions to populate this pipeline)

Pipeline_02_to_render_markdown:
  - _targets.R                           (Specific Pipeline setup file)
  - pipeline_render_markdown_functions.R (Specific function to populate this pipeline)
    
Pipeline_03_dynamic_branching files:
  - _targets.R                    (Specific Pipeline setup file)
  - dynamic_pipeline_functions.R  (Specific functions to populate this pipeline)

## 1. Targets quick start guide 

After installing the package, we load targets “library(targets)”. Then our first step is to run “**use_tergets()**” function. This **creates** a new file called **_tragets.R** that is used to **configure** and **setup** the **pipeline**.

Follow these steps then detailed in the R Documentation section of the use_targets() function: 

After you call use_targets(), there is still configuration left to do:

Open ⁠_targets.R⁠ and edit by hand. Follow the comments to write any options, packages, and target definitions that your pipeline requires.

Edit run.R and choose which pipeline function to execute (tar_make(), tar_make_clustermq(), or tar_make_future()).

If applicable, edit clustermq.tmpl and/or future.tmpl to configure settings for your resource manager.

If applicable, configure job.sh, "clustermq.tmpl", and/or "future.tmpl" for your resource manager.

## 1.1 Create single scripts for each analysis steps

- In this example I have started creating one script to load the data and another one to create a plot from that data

- See script: before_targets/**code_pre_targets.R**

## 1.2 Turn these single scripts into functions

There is a folder called "before targets" containing individual R scripts called "code_pre_targets.R" this script allows me to plan the analysis.
The second script "scripts_into_functions_targets_prep.R" contains new **functions** based on initial scripts to wwork with Targets package

- See script: before_targets/**scripts_to_functions.R**

## 1.3 Functions used by Targets saved in R folder

- The set of functions we want to run as part of our pipeline, are saved in the **R folder** for Targets to use them when executing the pipeline

- see script "study_functions.R" initial scripts for each analysis step turned into functions to be used in targets pipeline

- See script: R/**study_functions.R**
![2024-03-24_18-17_study_function_scripts_updated](https://github.com/Pablo-source/targets-test/assets/76554081/0b824425-8582-474a-980a-42ad87415ece)


## 1.4 Pipeline defined in the _targets.R file

pipeline
  - 1-4 Read in data
  - 2-4 Clean data
  - 3-4 Merge files
  - 3-4 Plot data
  - After the pipeline run we can run **report.Rmd** Markdown report and populate it with objects created by Targets pipeline. 
)

![2024-03-28_09-27_all_three_new_targets_plots](https://github.com/Pablo-source/targets-test/assets/76554081/337c2411-05c5-4bfd-8b04-23d71cfb649c)

All required files to run this pipeline saved in folder: **Pipeline_04_data_wrangling_union_merge**

## 1.5 Specific {targets} functions used to execute the pipeline 

Load targets library
library(targets)

- First check for errors in the pipeline using tar_manifest() function
tar_manifest(fields = command)

![2024-03-24_18-38_tar_manifest_output](https://github.com/Pablo-source/targets-test/assets/76554081/a40d770b-77d4-4c70-913e-2638fef3656a)

- Then check pipeline dependency graph using tar_visnetwork() function
tar_visnetwork()

- Finally we run the pipeline we just built earlier using tar_make() function
tar_make()

![Pipeline_functions](https://github.com/Pablo-source/targets-test/assets/76554081/41658ab8-959b-4eff-9007-f4ab76ea6f63)

The plot created from our pipeline is now saved as an individual .png chart


## 1.6 Run pipeline

Fnally we run the pipeline we just built earlier using tar_make() function
This function runs the correct targets in the correct order and saves the results to files
**tar_make()**

![05_Pipeline_completed_merged_files](https://github.com/Pablo-source/targets-test/assets/76554081/a4c488bf-92ac-49f8-825e-970fad4fc6e2)

## Pipeline 01. populate markdown with targets

Everytime we update something in the pipeline we use "tar_make()" to re-run the entire pipeline. If some of the targets have not changed since last time we ran the pipeline, targets will skip those nodes in the pipeline called targets.

The **tar_read()** function we collect the pipeline output object to be used in specific sections of the Markdown report. For example, to use the data frame we creaetd on the first target we use **tar_read(data)**. To use in the Markdown report the plot we created in the second Target object we use **tar_read(plot)**. This allows us to populate our markdown report with specific objects created alongside the pipeline we just built and ran.

The final output of this pipeline is being used to create a fully rendered markdown report produced by the markdown file **report.Rmd** has been created and published in this repo:
![Markdown_report_output](https://github.com/Pablo-source/targets-test/assets/76554081/196a9c12-938c-4757-bc11-33e74089a355)

The last step of this project has been building and rendering a markdown report called **report.Rmd** populated with the objects created in the pipeline by Targets. The aim is to autonmate the reports creation tasks by running a pipeline making it easier to mantain and update this report in the future.
When rendering **report.Rmd** we obtain a document populated with tables and content from the pipeline. This could be expanded to automate reports ensuring reproducibility. Trying to follow **RAP** principles.

So now we have an initial pipeline that we can start to modify and expand to include extra analytical steps in the form of new targets 

![rendered_markdown_report_from_targets_pipeline](https://github.com/Pablo-source/targets-test/assets/76554081/302f7f6b-41ad-4c41-9fd8-c65908aa7aa9)


## Pipeline 01. General pipeline structure using visnetwork 

First we will merge all incoming .csv files, then we combine them into a single file and we use this new combined data frmae to populate our Markdown report.

This is the output usuing tar_visnetwork() function to check pipeline dependency graph 

![2024-03-28_tar_visnetwork_plots_output](https://github.com/Pablo-source/targets-test/assets/76554081/6660f60e-0583-423f-ad86-9bda2199c932)

As part of the data preparation stage for future modelling pipeline

## Pipeline 01. Completed pipeline final output

This is the output of the complated pipeline run, with dataframes saved and required .csv files saved in the \objects folder

After using **tar_make()** function we get the complete report of which sections of the pipeline have ran

![2024-03-28_09-35_tar_manifest_all_charts_created](https://github.com/Pablo-source/targets-test/assets/76554081/04525e6e-5d3c-4be2-83dc-ea25ccd7cdd5)

All required files to run this pipeline saved in folder: **Pipeline_01_populate_markdown_with_targets**

## 1.Pipeline 02. Render Markdown in pipeline

We can render a Markdown document in the Targets pipeline by using {tarchetypes} library. This library provide us with the tar_render() function.  So by adding a new target to our pipeline, we can render the report after the pipeline has run and it has populated our Markdown report. 

![TARGETS_file_render_markdown](https://github.com/Pablo-source/targets-test/assets/76554081/2d0b8e93-7e9a-4a3b-a170-87613130f3ab)

And the rendering Targets function is now included in the pipeline: 
![VISNETWORK_render_report_targets](https://github.com/Pablo-source/targets-test/assets/76554081/2dd3128f-5c36-4a00-95ad-1fe628a5d76a)

After running the _targets file from this folder, we can automate the creation and rendering of a Markdown document inside the Targets pipeline

All required files to run this pipeline saved in folder: **Pipeline_02_to_render_markdown**

## 2.Pipeline 03. Dynamic branching and Time Series models forecast

Once the pipeline has run, before we implement a new feature (including a simple ARIMA model) defined in issue '#6', I have run **fs:dir_tree("targets-test")** to check whole set of objects created by Targets. The Markdown report has been populated by the three plots created in the pipeline.

In the coming week, I will be using **Dynamic branching** alongside **Modeltime** packages to introduce a couple of predictive models (ARIMA,Prophet) in the eixisting Pipeline. This is aimed to predict the next 5 months of Manufacturer's Value of Shipment for the following set of Shipment categories described below: 

### 2.1 Dynanic branching

It is a way to define new targets while the pipeline is running.  Opposed to declaring several targets up front. It is when you want to iterate over what is in the data, and you want a target that iterates by region.
-Dynamic branching using {targets}
<https://books.ropensci.org/targets/dynamic.html>

I will be using Dynamic branching to iterate over these four Economic Indicators downloaded from the FRED, Federal Reserve Economic Data:

Categories > Production & Business Activity > Manufacturing
<https://fred.stlouisfed.org/>

Monthly time series indicators downloaded from FRED Economic Data. St Louis: 

- Manufacturers' Value of Shipments: Total Manufacturing (AMTMVS). 2000-2024. Frequency: Monthly.
  U.S. Census Bureau, Manufacturers' Value of Shipments: Total Manufacturing [AMTMVS], retrieved from FRED, Federal Reserve Bank of St. Louis; April 2, 2024.Frequency: Monthly. Units:  Millions of Dollars, Seasonally Adjusted.
  URL: <https://fred.stlouisfed.org/series/AMTMVS>
- Manufacturers' Value of Shipments: Computers and Electronic Products (A34SVS). 2000-2024.
  U.S. Census Bureau, Manufacturers' Value of Shipments: Computers and Electronic Products [A34SVS], retrieved from FRED, Federal Reserve Bank of St. Louis; April 3, 2024. Frequency: Monthly. Units:  Millions of Dollars, Seasonally Adjusted.
  URL: <https://fred.stlouisfed.org/series/A34SVS>
- Manufacturers' Value of Shipments: Durable Goods (AMDMVS). 2000-2024. Frequency: Monthly
  U.S. Census Bureau, Manufacturers' Value of Shipments: Durable Goods [AMDMVS], retrieved from FRED, Federal Reserve Bank of St. Louis;  April 2, 2024.Frequency: Monthly. Units:  Millions of Dollars, Seasonally Adjusted.
  URL: <https://fred.stlouisfed.org/series/AMDMVS>
- Manufacturers' Value of Shipments: Nondefense Capital Goods Excluding Aircraft (ANXAVS). 2000-2024. Frequency: Monthly
  U.S. Census Bureau, Manufacturers' Value of Shipments: Nondefense Capital Goods Excluding Aircraft [ANXAVS], retrieved from FRED, Federal Reserve Bank of St. Louis; April 2, 2024.Frequency: Monthly. Units:  Millions of Dollars, Seasonally Adjusted.
  URL: <https://fred.stlouisfed.org/series/ANXAVS>

This is an example of dynamic branching using **tarchetypes** package based on Metric variable, creating 2 branches for the two metrics included in this workflow:
**tarchetypes** package GitHub repo:<https://github.com/ropensci/tarchetypes/tree/main> 

![VISNETWORK_tarchetypes_by_metric](https://github.com/Pablo-source/targets-test/assets/76554081/ca76b3d8-d8b6-4ae4-9d76-d866b82e233b)

![TARGETS_TEST_ISSUE_17_DYNAMIC_BRANCHING_ARIMA_01](https://github.com/Pablo-source/targets-test/assets/76554081/d24611bf-6751-4c99-b323-dca1df58a4ad)

![TARGETS_TEST_ISSUE_17_DYNAMIC_BRANCHING_Tarchetypes](https://github.com/Pablo-source/targets-test/assets/76554081/53465522-218d-40bb-8a53-e1c8715e91e4)

Visnetwork from the above workfow including branching

![VISNETWORK_graph_branch_by_metric](https://github.com/Pablo-source/targets-test/assets/76554081/9b9732b7-dfdb-4df0-add8-76edab4fc21a)

All required files to run this pipeline saved in folder: **Pipeline_03_dynamic_branching_files**

- This will allow me using Modeltime, to apply each model to the different branches created by Targets, so the model will ran by each metric in the pipeline

## 4.Pipeline 05. Dynamic branching including ARIMA and Prophet models 

This pipeline is completed and all required files to run it can be found in  "Pipeline_05_ARIMA_Prophet_models" folder: 

![2024-04-30_17-47_VISNETWORK_ARIMA_MODEL_final](https://github.com/Pablo-source/targets-test/assets/76554081/2b493c9e-e95d-4479-a97d-087c6cce52fd)

- Specific files to replicate this pipeline: "_targets.R","using_dynamic_predictive_pipeline.R" and "dynamic_predictive_pipeline_functions.R" this last one must be run from the \R folder 

![VISNETWORK_PROPHET_model](https://github.com/Pablo-source/targets-test/assets/76554081/4ba39fb8-93ac-4a7b-a265-1c3e670660d9)

Using Modeltime Package to combine Prophet and ARIMA models in the previous Targets Pipeline. Modeltime package: <https://business-science.github.io/modeltime/>
