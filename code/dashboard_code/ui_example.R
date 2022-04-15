df = structure(list(lng = c(101.901875, -95.712891, 108.339537, 37.618423
), lat = c(35.486703, 37.09024, 14.315424, 55.751244), country = structure(c(1L, 
                                                                             3L, 4L, 2L), .Label = c("China", "Russia", "USA", "Vietnam"), class = "factor"), 
number = c(35500L, 6267L, 2947L, 3070L)), .Names = c("lng", 
                                                     "lat", "country", "number"), class = "data.frame", row.names = c(NA, 
                                                                                                                      -4L))

library(shiny)
library(leaflet)

ui <- (fluidPage(
  titlePanel(title = "Pig breeding countries in 2000 - Top 5"),
  sidebarLayout(
    sidebarPanel( uiOutput("countrynames")
    ),
    mainPanel(leafletOutput("mymap", height = "500")
    ))
)
)

server <- function(input, output){
  output$countrynames <- renderUI({
    selectInput(inputId = "country", label = "Select a country to view it's values (you can choose more than one):",
                c(as.character(df$country)))
  })
  map_data <- reactive({
    data <- data.frame(df[df$country == input$country,])
    data$popup <- paste0(data$country, " ", data$number)
    return(data)
  })
  output$mymap <- renderLeaflet({
    leaflet(data = map_data()) %>%
      # setView( lng = -16.882374406249937, lat = -1.7206857960062047, zoom = 0) %>%
      addProviderTiles( provider = "CartoDB.Positron") %>%
      addMarkers(lng = ~lng, lat = ~lat, popup = ~popup)
    # addCircles(lng = ~lng, lat = ~lat, popup = ~popup)
  })
}
shinyApp(ui, server)