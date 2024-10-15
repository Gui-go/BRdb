


library(dplyr)
library(ggplot2)



df_emig <- readr::read_tsv("clean_bucket/tabela3173_emig_micro.tsv")
names(df_emig) = c("cd_micro", "nm_micro", "emig_total", "emig_africa", "emig_southafrica", "emig_angola", "emig_other_african_countries", "emig_central_america", "emig_north_america", "emig_canada", "emig_united_states", "emig_mexico", "emig_south_america", "emig_argentina", "emig_bolivia", "emig_chile", "emig_french_guiana", "emig_paraguay", "emig_suriname", "emig_uruguay", "emig_venezuela", "emig_other_south_american_countries", "emig_asia", "emig_china", "emig_japan", "emig_other_asian_countries", "emig_europe", "emig_germany", "emig_austria", "emig_belgium", "emig_spain", "emig_france", "emig_netherlands", "emig_ireland", "emig_italy", "emig_norway", "emig_portugal", "emig_united_kingdom", "emig_sweden", "emig_switzerland", "emig_other_european_countries", "emig_oceania", "emig_australia", "emig_new_zealand", "emig_other_oceanian_countries", "emig_not_declared")
df_emig[df_emig == "-"] <- "0"
numeric_columns = names(df_emig)[3:length(df_emig)]
df_emig[numeric_columns] <- lapply(df_emig[numeric_columns], as.numeric)
str(df_emig)
summary(df_emig)
# sapply(df_emig, function(x) sum(is.na(x)))

df_emig %>%
  arrange(desc(emig_total)) %>%
  select(cd_micro, nm_micro, emig_total) %>%
  head(10)


# Plot total emigration by micro-region
ggplot(df_emig, aes(x = reorder(nm_micro, emig_total), y = emig_total)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Total Emigration by Micro-Region", x = "Micro-Region", y = "Total Emigration") +
  theme_minimal()
