# R-script data_exports.R

# Treating and grouping exports data 

# References --------------------------------------------------------------

# https://www.gov.br/produtividade-e-comercio-exterior/pt-br/assuntos/comercio-exterior/estatisticas/base-de-dados-bruta
# Seção 2: Base de dados detalhada por Município da empresa exportadora/importadora e Posição do Sistema Harmonizado (SH4)

# data_exports function ---------------------------------------------------
data_exports <- function(){
  
  # Getting BR location info
  source("BRdb/modules/compute/scripts/data_locations.R")
  br_loc <- data_loc()
  
  # Dados 2010
  # Loading exp data
  exp <- vroom::vroom(file = "clean_bucket/munic/EXP_COMPLETA_MUN.csv") %>% 
    janitor::clean_names() %>% 
    dplyr::select(cd_mun=co_mun, year=co_ano, sg_uf=sg_uf_mun, cd_sh4=sh4, exports=vl_fob) %>% 
    dplyr::mutate(
      exports = dplyr::if_else(is.na(exports), 0, exports),
      cd_mun = dplyr::case_when(
        sg_uf == "SP" ~ as.character(cd_mun + 100000), # SP
        sg_uf == "GO" ~ as.character(cd_mun - 100000), # GO
        sg_uf == "MS" ~ as.character(cd_mun - 200000), # MS
        sg_uf == "DF" ~ as.character(cd_mun - 100000), # DF
        TRUE ~ as.character(cd_mun) # Keep unchanged if no match
      )
    ) %>% 
    dplyr::group_by(cd_mun, year, cd_sh4) %>%
    dplyr::summarise(exports = sum(exports, na.rm = T), .groups = "drop") %>% 
    dplyr::left_join(br_loc, .) %>% 
    dplyr::ungroup() %>% 
    as.data.frame() %>% 
    suppressMessages(); gc()
  
  
  if(grouped_by == "mun"){}else
    if(grouped_by == "micro"){
      exp <- exp %>% 
        dplyr::group_by(cd_micro, cd_sh4) %>% 
        dplyr::summarise(exports = sum(exports, na.rm = T), .groups = "drop")
    }else
      if(grouped_by == "meso"){
        exp <- exp %>% 
          dplyr::group_by(cd_meso, cd_sh4) %>% 
          dplyr::summarise(exports = sum(exports, na.rm = T), .groups = "drop")
      }else
        if(grouped_by == "rgime"){
          exp <- exp %>% 
            dplyr::group_by(cd_rgime, cd_sh4) %>% 
            dplyr::summarise(exports = sum(exports, na.rm = T), .groups = "drop")
        }else
          if(grouped_by == "rgint"){
            exp <- exp %>% 
              dplyr::group_by(cd_rgint, cd_sh4) %>% 
              dplyr::summarise(exports = sum(exports, na.rm = T), .groups = "drop")
          }else
            if(grouped_by == "uf"){
              exp <- exp %>% 
                dplyr::group_by(cd_uf, cd_sh4) %>% 
                dplyr::summarise(exports = sum(exports, na.rm = T), .groups = "drop")
            }else
              if(grouped_by == "rg"){
                exp <- exp %>% 
                  dplyr::group_by(sg_reg, cd_sh4) %>% 
                  dplyr::summarise(exports = sum(exports, na.rm = T), .groups = "drop")
              }

  
  
  return(exp)
  
}

# exp <- data_exports()


