# dashboard code: simple dashboard example
# https://www.youtube.com/watch?v=41jmGq7ALMY&ab_channel=Appsilon

# libraries necessary

# an R package that makes it easy to build interactive web apps straight from R
library(shiny)
# a library that makes it easy to use Shiny to create dashboards
library(shinydashboard)
# an open source JavaScript library used to build web mapping applications
library(leaflet)

library(sf)

library(shinythemes)

library(readr)

library(rsconnect)

# Taking advantage of shiny dashboard components, we can: 
#   - create a dashboard page, fill it with content (header, sidebar, body)
ui <- dashboardPage(
  dashboardHeader(title = "FillThis"),
  dashboardSidebar(),
  dashboardBody(
    # Start the plot in the dashboard body
    box(plotOutput("correlation_plot"), width = 8),
    # Box with a component for a widget drop-down menu
    box(
      # Need choices for the widget's 
      selectInput("features","features:",
                  c("Sepal.Width","Petal.Length",
                    "Petal.Width")), width = 4
    )
  )
)

# create a server function, taking input and output variables
server <- function(input, output){
  output$correlation_plot <- renderPlot({
    # in this example, we see a simple plot with iris Sepal and Petal lengths
    # we need the input from the selectInput function above to correspond with
    #  the options below
    plot(iris$Sepal.Length, iris[[input$features]],
         xlab = "Sepal Length", ylab = "Feature")
  })
}
  
# create a call to the server and UI
shinyApp(list(ui, server))