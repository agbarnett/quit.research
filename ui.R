# When should I quit research
# Feb 2017
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  tags$h2("When should I quit research?"),
  p("If you are thinking of quitting research then what better way to quit than based on evidence?
    This page contains a Bayesian calculator that combines a prior probability of ability with your number of failed applications.
    Change the mean probability below based on historical data from the schemes you've applied to (e.g., if around 20 out of 100 applicants were funded then set the probability to 0.2).
    Next change the prior successes to give a realistic prior probability of ability, this can be selected using trial and error.
More prior successes give a narrower prior around the mean; a prior success of zero gives a flat uniform prior.
Then input your total number of failed applications (no successes allowed).
If your probability of being below average is greater than 0.90, then perhaps you should quit.
    For further details see this",
    tags$a(href="http://aushsiblog.com/?p=170", "blog post"), '.'),
  
  sidebarLayout(
    sidebarPanel(
      h4('These two parameters control the prior (which is a beta distribution)'),
      
      numericInput(inputId = "mean.prob",
                              label = "Mean probability of success",
                              min = 0,
                              max = 1,
                              step = 0.01,
                              value=0.20),
                 
                 numericInput(inputId = "prior.success",
                              label = "Prior number of successes",
                              min = 0,
                              max = 5,
                              step = 1,
                              value=1),
    
      h4('This parameter controls the posterior'),
         numericInput(inputId = "n.fail",
                              label = "Number of observed failures",
                              min = 0,
                              max = 40,
                              step = 1,
                              value = 3)
    ),
    
    mainPanel(h3('Probability of being below average'),
              textOutput(outputId = 'p_text'),
              h3('Plot of prior and posterior probabilities'),
              plotOutput(outputId = "main_plot", width = "80%")
    ) # end of main panel
  )
))

