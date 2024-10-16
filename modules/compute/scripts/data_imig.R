


library(dplyr)
library(ggplot2)
library(janitor)


df_imig <- readr::read_tsv("clean_bucket/micro/tabela2145_imig_micro.tsv") %>%
  janitor::clean_names(.) %>% 
  stats::na.omit(.) %>% 
  dplyr::mutate(imig=as.numeric(total)) %>%
  dplyr::select(cd_micro=cod, nm_micro=microrregiao_geografica, imig) %>% 
  dplyr::arrange(desc(imig)) %>%
  suppressMessages() %>% 
  suppressWarnings()

  
  
ggplot(df_imig[1:20, ], aes(x = reorder(nm_micro, imig), y = imig)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Total Imigration by Micro-Region", x = "Micro-Region", y = "Total Imigration") +
  theme_minimal()

  
  