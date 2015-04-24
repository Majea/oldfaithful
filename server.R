
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(caret)
data(faithful)

predictEruptionDuration <- function(waitingTime, seed, trainingRatio){
    # exercice taken from Coursera course 'Practical machine learning', lesson 'predicting with regression'
    
    # predict eruption duration according to the waiting time between 2 eruptions
    # of Old Faithful geyser in USA
    # waiting time between eruptions and the duration of the eruption for the Old Faithful geyser
    # in Yellowstone National Park, Wyoming, USA.
    set.seed(seed)
    inTrain <- createDataPartition(y=faithful$waiting, p=trainingRatio/100, list=FALSE)
    trainFaith <- faithful[inTrain,]
    testFaith <- faithful[-inTrain,]
    headData <- head(trainFaith)
    
    lm1 <- lm(eruptions ~ waiting, data=trainFaith)
    summaryData <- summary(lm1)
    
    # EDi = b0 + b1*WTi + ei
    # coef(lm1)[1] is b0
    # coef(lm1)[2] is b1
    
    prediction = coef(lm1)[1] + coef(lm1)[2]*waitingTime
    
    trainingSetError = sqrt(sum((lm1$fitted-trainFaith$eruptions)^2))
    testSetError = sqrt(sum((predict(lm1, newdata=testFaith)-testFaith$eruptions)^2))
    
    list(headData = headData,
         summaryData = summaryData,
         prediction = prediction,
         trainingSetError = trainingSetError,
         testSetError = testSetError,
         trainFaith = trainFaith,
         testFaith = testFaith,
         lm1 = lm1)
    
}

shinyServer(function(input, output) {
    data <- reactive({
        predictEruptionDuration(input$waitingTime, input$seed, input$trainingRatio)
    })
    
    output$distPlot <- renderPlot({
        par(mfrow=c(1, 2))
        plot(data()$trainFaith$waiting,
             data()$trainFaith$eruptions,
             pch=19, col="blue",
             xlab="Waiting", ylab="Duration", main="Training data and predictor")
        lines(data()$trainFaith$waiting, predict(data()$lm1), lwd=3)
        plot(data()$testFaith$waiting,
             data()$testFaith$eruptions,
             pch=19, col="blue",
             xlab="Waiting", ylab="Duration", main="Testing data and predictor")
        lines(data()$testFaith$waiting, predict(data()$lm1, newdata=data()$testFaith), lwd=3)
    })
  
    output$prediction <- renderPrint({data()$prediction})
    output$trainingSetError <- renderPrint({data()$trainingSetError})
    output$testSetError <- renderPrint({data()$testSetError})
})
