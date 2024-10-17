# R-script main_pipeline.R

# References --------------------------------------------------------------

# A pipeline to call functions sequentially

# Setup -------------------------------------------------------------------

# rm(list = ls())
gc()
source("BRdb/modules/compute/scripts/util_loadPackages.R")
# source("fct_createDF.R")
# source("fct_global.R")
# source("fct_local.R")
# source("fct_corMatrix.R")

library(readr)
df_exports_micro <- readr::read_csv("curated_bucket/df_exports_micro.csv")











