shinyUI(
  navbarPage(
    title = "Luminex App",
    theme = "styles.css",
    
    tabPanel(
      title = "Home",
      h1("About"),
      h4(about),
      imageOutput(outputId = "luminex_image" )
      
    ),
    
    tabPanel(
      title = "Analysis",
      
      sidebarLayout(
        
        sidebarPanel(
          
          fileInput(
            inputId = "upload_file",
            label = "Upload your luminex rds file here: ",
            placeholder = "No file selected yet",
            multiple = FALSE,
            accept = c(".rds")
          ),
          
          # actionButton(
          #   inputId = "reset",
          #   label = "reset data",
          # ),
          
          checkboxInput(
            inputId = "head_data",
            label = "Display first 10 rows of your data? ",
            value = FALSE
          ),
          
          selectInput(
            inputId = "analyte_1",
            label = "select first analyte for correlation test",
            choices = NULL
          ),
          
          selectInput(
            inputId = "analyte_2",
            label = "select second analyte for correlation test",
            choices = NULL
          ),
          
          selectInput(
            inputId = "cor_type",
            label = "correlation type",
            choices = c("pearson", "spearman")
          ),
          
          checkboxInput(
            
            inputId = "show_cor_tab",
            label = "show correlation table ?",
            value = FALSE
          ),
          # splitLayout(cellWidths = c(60, 50), selectInput(inputId = "analyte_1",
          #                                                       label = "analyte 1",
          #                                                       choices = unique(data$analyte)), selectInput(inputId = "analyte_2",
          #                                                                                                    label = "analyte 2",
          #                                                                                                    choices = unique(data$analyte))),
          # 
        ),
      
        mainPanel(
         
          dataTableOutput("head_data_txt"),
          
          h4(textOutput("cor_result")),
          
          dataTableOutput("show_cor_tab"),
        )
      )
    ),
    
    tabPanel(
      title = "Visualisation",
      
      sidebarLayout(
        
        sidebarPanel(
          
          selectInput(
            inputId = "graphs",
            label = "select type of graph to visualise",
            choices = graph_type
          ),
          
          selectInput(
            inputId = "transform",
            label = "Select transformation type",
            choices = c("log", "box-cox", "no transformation")
          ),
          
          selectInput(
            inputId = "analyte_plot",
            label = "select analyte to visualise",
            choices = NULL
          ),
         
          tabsetPanel(
            id = "switch",
            type = "hidden",
            tabPanel("histogram",
                     
                     sliderInput(
                       inputId = "bins",
                       label = "number of bins for histogram",
                       min = 1,
                       value = 30,
                       max = 50)
            ),
            
            tabPanel("boxplot",
                     NULL

            ),

            tabPanel("q-q plot",
                 NULL
            )
            
          )
          
        ),
        
        mainPanel(
          plotOutput("individual_plot"),
          
          h4(textOutput("graph")),
        )
      )
      
    )
  )
)

