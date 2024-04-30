# dynamic_predictive_pipeline_functions.R

# All the code in this Rscript works fine !!!
clean_computer_data <- function(Computer_data_input){
  
  # TARGET 01: Read in computers good data  
  # Input file 01-04: A34SVS_Shipments_value_Computer_products.csv  
  
  computer_data <- read_csv(Computer_data_input,col_types = cols()) %>%
    as_tibble() %>%
    clean_names() %>%
    select(date, value = a34svs) %>% 
    mutate(Metric = "Computer_goods") %>% 
    filter(!is.na(value)) %>% 
    select(date,value,Metric)
  computer_data
}
# TARGET 02: Read in Durable goods data
clean_durable_goods_data <- function(Durable_goods_input){
  
  durable_goods <- read_csv(Durable_goods_input,col_types = cols()) %>%
    as_tibble() %>%
    clean_names() %>%
    select(date, value = amdmvs) %>% 
    mutate(Metric = "Durable_goods") %>% 
    filter(!is.na(value)) %>% 
    select(date,value,Metric)
  durable_goods
}
# TARGET 03: Union both files
# Append (union) "computer_data" and "Durable_goods" files 

union_computer_durable <- function (computer_data, durable_goods){
  
  file_one <- computer_data
  file_two <- durable_goods
  
  computer_durable <- bind_rows(file_one,file_two)
  write.csv(computer_durable,here("objects","union_computer_durable.csv"),row.names = TRUE)
  
  computer_durable
}

# TARGETS 04: Split groups between TRAIN and TEST sets
# Required library: library(rsample) 
# Function: initial_time_split()

test_train_split <-function(grouped_by_metric){
  
  splits_perc <- initial_time_split(grouped_by_metric, prop = 0.8)
  splits_perc
  
  train_data <- training(splits_perc)
  test_data <- testing(splits_perc)
  
  train_data
  test_data
  
}


# TARGET 05: ARIMA MODEL
# Required library: parsnip (use set_engine()), modeltime (arima_reg())
# Required PARSNIP package to use set_engine() function

ARIMA_model <- function(train_data){
  
  model_spec_arima <- arima_reg() %>%
    set_engine(engine = "auto_arima") 
  
  # Fit ARIMA model to data
  model_fit_arima <- model_spec_arima %>% 
    fit(value ~ date, data = train_data)
  model_fit_arima
}

# TARGET 05: PROPHET MODEL
# Required library: parsnip (use set_engine()), modeltime (prophet_reg())

PROPHET_model <- function(train_data){
  
  model_spec_prophet <- prophet_reg() %>%
    set_engine("prophet")
  
  # Fit PROPHET model to data
  model_fit_prophet <- model_spec_prophet %>% 
    fit(log(value) ~ date, data = train_data)
  model_fit_prophet
  
}
