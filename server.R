# for cost of resistant e-coli
# Feb 2017
library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  source('Decision.Tool.function.R')
  
  output$p_text <- renderText({
    results = quit(mean.prob=input$mean.prob, prior.success=input$prior.success, n.fail=input$n.fail)
    paste('Probability = ', round(results$bottom*100)/100, '.', sep='')
  })
  
  output$main_plot <- renderPlot({
    results = quit(mean.prob=input$mean.prob, prior.success=input$prior.success, n.fail=input$n.fail)
    print(results$plot)
  })
  
  
})

