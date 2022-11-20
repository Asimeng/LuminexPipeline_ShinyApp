library(car)

filter_analyte_bc <- function(dt, anlyt_name){
  
  dat <- dt %>% filter(analyte == anlyt_name) %>% 
    select(analyte, obs_conc)
  
  lambda <- powerTransform(dat$obs_conc)$lambda
  
  dat <- dat %>% mutate(bc = ((obs_conc^lambda - 1)/lambda))
  
  return(dat)
  
}

filter_analyte_log <- function(dt, anlyt_name){
  
  dat <- dt %>% filter(analyte == anlyt_name) %>% 
    select(analyte, obs_conc) %>% 
    
    mutate(log = log(obs_conc))
  
  return(dat)
  
}