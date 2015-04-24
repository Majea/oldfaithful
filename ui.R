
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  headerPanel("Old Faithful Geyser Eruption Prediction"),
  p(paste('This application predicts the duration of an eruption of the Old Faithful geyser (USA) ',
          'according to the waiting time between two eruptions. ',
          'Your input is on the left side and the result is on the right side. ',
          'Specify a waiting time in minutes on the left side ',
          'using the \'waiting time between eruptions \' slider. ',
          'The application will predict how long the eruption will last ',
          'in minutes (predicted eruption duration).'
          )),
  p(paste('See below for more detailed explanations of the other parameters and results.')),
  br(),
  
  sidebarLayout(
      sidebarPanel(
        sliderInput("waitingTime",
                    "Waiting time between eruptions [mins]: ",
                    min = 1,
                    max = 200,
                    value = 50),
        sliderInput('trainingRatio',
                    'Percentage of data assigned to the training set: ',
                    value=50, min=10, max=100, step=1),
        numericInput('seed', 'Seed: ', 333, min=0, step=1)
      ),
      
      mainPanel(
          h4('Predicted eruption duration [mins]: '),
          verbatimTextOutput('prediction'),
          plotOutput('distPlot'),
          div('Error on training set: '),
          verbatimTextOutput('trainingSetError'),
          div('Error on test set: '),
          verbatimTextOutput('testSetError')
      )
  ),
  h4('Detailed explanations of parameters and results'),
  p('You can modify the following parameters:'),
  tags$ul(
      tags$li(paste('Waiting time between eruptions: ',
                    'we \'ll predict eruption time according to this waiting time (in minutes). ',
                    'So this is the prediction input.')),
      tags$li(paste('Percentage of data assigned to training set: ',
                    'the error of the prediction algorithm is estimated by verifying ',
                    'how good the predictions are on known results. ',
                    'Out set of data for which we know the results is divided into a training and a test set. ',
                    'The training set is used to produce the prediction formula while the test set is not. ',
                    'So the test set brings a better idea of the real prediction error. ',
                    'Adding more values to the training set usually brings better predictions ',
                    'but having more values on the test set may bring a better estimation of the error. ',
                    'We need to find the right balance between test set and training set.')),
      tags$li(paste('Seed: ',
                    'the prediction algorithm depends on some pseudo-random numbers generation. ',
                    'You can set the seed of the number generator here and see how it influences the prediction.'))
      ),
  p('The results are: '),
  tags$ul(
      tags$li(paste('Predicted eruption duration: ',
                    'the number of minutes the eruption will last if the time since the last eruption ',
                    'is the number specified in \'waiting time between eruptions\', in minutes.')),
      tags$li(paste('Error on training set: ',
                    'the error calculated by comparing predicted values and real values ',
                    'on the training set. ')),
      tags$li(paste('Error on test set: ',
                    'the error calculated by comparing predicted values and real values ',
                    'on the test set. '))
  ),
  p(paste('This application is based on material from Coursera class \'Practical machine learning\' ', 
          'instructed by Brian Caffo, Jeff Leek and Roger Peng - https://www.coursera.org/course/predmachlearn'))
  
))
