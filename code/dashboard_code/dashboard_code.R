# dashboard code: simple dashboard example
# Dashboard basics: https://www.youtube.com/watch?v=41jmGq7ALMY&ab_channel=Appsilon
# Interactive map dashboard: https://byollin.github.io/ShinyLeaflet/#25

# libraries necessary
library(shiny)
library(shinydashboard)

###########################################################################
# Using the early bus data and the cancelled bus data, map bus performance.
###########################################################################

# from the CSVs, create point data for each stop
# from the CSVs, create point data for each early stop (bigger, clickable)
# from the CSVs, create point data for each early stop (bigger, clickable)
# from the CSVs, create point data for each bus route (bigger, clickable)



###########################################################################
# Load maps to the dashboard.
###########################################################################

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
shinyApp(ui, server)