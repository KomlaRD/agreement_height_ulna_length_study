#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(reticulate)
library(glue)


use_condaenv("predicting_height", required = TRUE)

ui <- fluidPage(
  # UI elements
  titlePanel("Height predictor"),
  numericInput("age", "Age in years", value = 55),
  selectInput("gender", "Sex", choices =  c("Male" = "male", "Female" = "Female")),
  numericInput("mean_ulna", "Ulna length in cm", value = 25),
  actionButton("predict", "Predict"),
  textOutput("prediction")
)

server <- function(input, output) {
 
  # Import joblib
  joblib <- import("joblib")
  model <- joblib$load("linear_model.joblib")
  print(model)
  
  observeEvent(input$predict, {
    
    # One-hot encoding for gender
    # The column names 'gender_1' and 'gender_2' should match the training data's feature names
    gender_1 <- ifelse(input$gender == "female", 1, 0)  # Adjust the condition to match your specific data
    gender_2 <- ifelse(input$gender == "male", 1, 0)  # Adjust the condition to match your specific data
    
    
    if (is.null(input$age) || is.null(input$mean_ulna) || is.null(input$gender)) {
      # Handle the case where one or more inputs are missing
      # You can update this part to show a message to the user, if needed
      output$prediction <- renderText("Please provide all inputs.")
      return()
    }
    
    # Prepare the input data as a numeric matrix
    data <- data.frame(age = as.numeric(input$age), 
                       gender_1 = gender_1, 
                       gender_2 = gender_2,
                       mean_ulna = as.numeric(input$mean_ulna))
    
    # Predict using the scikit-learn model
    prediction <- model$predict(data)
    
    # Determine the output text based on the prediction
    output_text <- glue("The predicted height is", round(prediction, 1), " cm") 

    # Display the output text
    output$prediction <- renderText({output_text})
  })
}

shinyApp(ui = ui, server = server)