library(shiny)

shinyServer(function(input, output){
  
  output$luminex_image <- renderImage(
    list(src = "www/luminex_logo.png",
         width = "300px")
  )
  
  data <- reactive({
    
    if (!is.character(input$upload_file$datapath) && length(input$upload_file$datapath) < 1 ){
      
      data <- read_rds("www/dat.rds")
      
      data
      
      } else{
      
      req(input$upload_file)
    
    ext <- tools::file_ext(input$upload_file$name)
    
    switch(ext,
           rds = read_rds(input$upload_file$datapath),
           
           validate("Invalid file; Please upload a valid, processed and cleaned Luminex .rds file")
    )
  }
    
  })
  
  
  names_analytes <- reactive(unique(data()$analyte))
  
  observeEvent(data(), {
    
    updateSelectInput(inputId = "analyte_1", choices = names_analytes())
    
    updateSelectInput(inputId = "analyte_2", choices = names_analytes())
    
    updateSelectInput(inputId = "analyte_plot", choices = names_analytes())
    
  })
  
  
  piv_dat <- reactive({
    
    data() %>%
      
      select(analyte, obs_conc) %>% 
      
      group_by(analyte) %>%
      
      mutate(row = row_number()) %>% 
      
      pivot_wider(
        names_from = analyte,
        values_from = obs_conc) %>%
      
      select(-row) 
    
  })
 
  
  output$head_data_txt <- renderDataTable({
    
    if (input$head_data == TRUE){
      
      head(data(), 10)
    
    } else {
      
       NULL
    }
  }
  )
  
  
  output$show_cor_tab <- renderDataTable(
   
    if (input$show_cor_tab == TRUE & input$cor_type == "spearman") {
      
      correlation_table(data(), "spearman")
      
    } else if(input$show_cor_tab == TRUE & input$cor_type == "pearson") {
      
     correlation_table(data(), "pearson")
      
    } else {
      
      NULL
    }
  )
  
  corr <- reactive(cor(
    
    x = piv_dat()[input$analyte_1],
    
    y = piv_dat()[input$analyte_2],
    
    use = "pairwise.complete.obs",
    
    method = input$cor_type))
  
  cor_text <-  reactive(paste0(
    
    "The ",
    input$cor_type,
    " correlation coefficient of ",
    input$analyte_1, " and ", input$analyte_2, 
    " is ", round(corr(), digits = 3)))
  
  
  output$cor_result <- renderText({
    
    cor_text()
    
    })
  
  
  observeEvent(input$graphs, {
    
    updateTabsetPanel(inputId = "switch", selected = input$graphs)
    
  })
  
      
  bc_dat <- reactive(filter_analyte_bc(data(), anlyt_name = input$analyte_plot))
  
  log_dat <- reactive(filter_analyte_log(data(), anlyt_name = input$analyte_plot))
  
  new_dat <- reactive(filter(data(), analyte == input$analyte_plot))
 
  
  histo <- function(dat, num_var){
    
    ggplot(dat, aes(x = num_var)) +
      
      geom_histogram(bins = input$bins, colour = "black", fill = "grey", na.rm = TRUE) +
      
      labs(x = "conc", y = "count")
  }
  
  output$individual_plot <- renderPlot({
    
    if (input$transform == "log" & input$graphs == "boxplot") {boxp(log_dat(), log_dat()$log)}
    
   else if (input$transform == "log" & input$graphs == "histogram") {histo(log_dat(), log_dat()$log)}
    
   else if (input$transform == "log" & input$graphs == "q-q plot") {qq(log_dat(), num_var = log_dat()$log)}
    
   else if (input$transform == "box-cox" & input$graphs == "boxplot") {boxp(bc_dat(), bc_dat()$bc)}
    
   else if (input$transform == "box-cox" & input$graphs == "histogram") {histo(bc_dat(), bc_dat()$bc)}
    
   else if (input$transform == "box-cox" & input$graphs == "q-q plot") {qq(bc_dat(), num_var = bc_dat()$bc)}
    
   else if (input$transform == "no transformation" & input$graphs == "boxplot") {boxp(new_dat(), new_dat()$obs_conc)}
    
   else if (input$transform == "no transformation" & input$graphs == "histogram") {histo(new_dat(), new_dat()$obs_conc)}
    
   else if (input$transform == "no transformation" & input$graphs == "q-q plot") {qq(new_dat(), num_var = new_dat()$obs_conc)}
    
   else {NULL}
      
  }, res = 96)
  
  output$graph <- renderText(
    
    paste("You are visualising", input$analyte_plot, 
          "in a", input$graphs, "with a", 
          input$transform, "transformation")
  )
  
})

