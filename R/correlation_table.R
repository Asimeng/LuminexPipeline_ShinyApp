library(Hmisc)
library(tidyr)
library(dplyr)

correlation_table <- function(dat, type){
  
  piv_dat <- dat %>% 
    
    select(analyte, obs_conc) %>% 
    
    group_by(analyte) %>%
    
    mutate(row = row_number()) %>% 
    
    pivot_wider(
      names_from = analyte,
      values_from = obs_conc) %>%
    
    select(-row)
    
  
  cor <- rcorr(as.matrix(piv_dat), type = type)
  
  flattenCorrMatrix <- function(cormat, pmat) {
    ut <- upper.tri(cormat)
    data.frame(
      row = rownames(cormat)[row(cormat)[ut]],
      column = rownames(cormat)[col(cormat)[ut]],
      cor  =(cormat)[ut],
      p = pmat[ut]
    )
  }
  
  cor <- flattenCorrMatrix(cor$r, cor$P)
  
  arr_cor <- arrange(cor, desc(abs(cor))) %>% 
    
    filter(!is.na(cor))
  
  arr_cor
}
