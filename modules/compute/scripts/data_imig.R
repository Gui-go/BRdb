


library(dplyr)
library(ggplot2)
library(janitor)


df_imig <- readr::read_tsv("clean_bucket/micro/tabela2145_imig_micro.tsv") %>%
  janitor::clean_names(.) %>% 
  stats::na.omit(.) %>% 
  dplyr::mutate(imig=as.numeric(total)) %>%
  dplyr::select(cd_micro=cod, imig) %>% 
  suppressMessages() %>% 
  suppressWarnings()

  
  
  
  
  