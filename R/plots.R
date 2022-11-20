library(ggplot2)

boxp <- function(dat, num_var){
  ggplot(dat, aes(y = num_var)) + 
    geom_boxplot(na.rm = TRUE) +
    labs(y = "conc")
}

qq <- function(dat, num_var){
  qqplot <-  ggplot(dat, aes(sample = num_var)) +
    stat_qq()+
    stat_qq_line()
  
  qqplot
}