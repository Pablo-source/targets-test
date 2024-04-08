# dynamic_pipeline_functions.R
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

