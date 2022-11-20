library(shiny)
library(readr)
library(dplyr)
library(Hmisc)

graph_type <- c("histogram", "boxplot", "q-q plot")

# data <- read_rds("www/dat.rds")


about <- tags$div(
  
  tags$p("The Luminex pipeline is an R-based pipeline that reads .txt 
files produced by Luminex instruments and outputs experimental data, quality
control data and metadata. This app is created to visualise and explore statistical summaries
from pipeline output (data).  More specifically, correlation analysis(Pearson and Spearman) between analytes
and visualisation of the effects of transformation (Box-Cox and log) on analyte distributions"), 
  
  tags$p("USAGE: For purposes of exploration (assessing functionality of the app), a very small underlying data
is provided. One can, however, upload their processed Luminex data for use on the app - this will override
the underlying data."), 
  
  tags$p("WARNING: This app/utility is meant for exploratory analysis only and should only be used as such!")
)

luminex_image <- tags$img(src = "www/luminex_logo.png", width = "100px", height = "100px")

