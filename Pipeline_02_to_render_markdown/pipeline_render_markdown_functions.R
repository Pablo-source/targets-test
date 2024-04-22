# R script: pipeline_render_markdown_functions.R

# TARGET 01: IMPORT EXCEL FILE
clean_ATT_data_function <- function(AE_data_input){
  
  
  clean_ATT_data <- read_excel(AE_data_input, 
                               col_types = c("date", "numeric", "numeric", 
                                             "numeric", "numeric", "numeric", "numeric", "numeric", 
                                             "numeric", "numeric", "numeric", "numeric", "numeric", 
                                             "numeric", "text", "numeric", "numeric"), skip = 13) %>% 
    clean_names() %>% 
    select(period,
           AE_att_TypeI_dbl = type_1_departments_major_a_e,
           AE_att_TypeII_dbl =  type_2_departments_single_specialty,
           AE_att_TypeIII_dbl = type_3_departments_other_a_e_minor_injury_unit,
           Total_attendances = total_attendances) %>% 
    mutate(date = as.Date(period)) %>%                    # Works fine up to this point
    mutate(
      AE_att_TypeI = as.integer(AE_att_TypeI_dbl),
      AE_att_TypeII = as.integer(AE_att_TypeII_dbl),
      AE_att_TypeIII = as.integer(AE_att_TypeIII_dbl)
    ) %>% 
    select(date,AE_att_TypeI,AE_att_TypeII,AE_att_TypeIII)
  clean_ATT_data
  
}


# Target to pivot data

pivot_data <- function(clean_ATT_data){
  
  
  AE_data_long <- clean_ATT_data %>% 
                 pivot_longer(names_to = "Type",
                 cols = 2:ncol(clean_ATT_data))
  AE_data_long
  
  
}
  

# Target to plot chart for report

plot_data <- function(AE_data_long){

  data_area_chart <- AE_data_long %>% select(date,Type,value) 
  
  area_chart <- ggplot(data_area_chart, aes(x = date, y = value, fill = Type)) +
    labs(title = "A&E Attendances by type. 2010-2024 period",
         subtitle = "TypeI, TypeII, TypeIII A&E Attendances by month",
         x = "Period", y = "Value" ) +
    geom_area(alpha = 0.6, linewidth = .5, colour = "white") 
  
  area_chart
  
}


