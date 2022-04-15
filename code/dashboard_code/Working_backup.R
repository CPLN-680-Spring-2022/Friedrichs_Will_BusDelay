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


points = st_read('https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/stops_by_route/routestops.dbf') 
points = st_as_sf(points,  coords = c("Lon", "Lat"))

# Create temp files
temp <- tempfile()
temp2 <- tempfile()
# Download the zip file and save to 'temp' 
URL <- 'https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/polyline_routes/busroutes.zip'
download.file(URL, temp)
# Unzip the contents of the temp and save unzipped content in 'temp2'
unzip(zipfile = temp, exdir = temp2)
# Read the shapefile
routes = sf::read_sf(temp2)



ui <- fluidPage(
  leafletOutput("mymap")
)

server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    # The leaflet function creates the zoomable image. 
    leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
      # This adds the pre-package basemap (Positron = day, DarkMatter = night)
      addProviderTiles(providers$CartoDB.DarkMatter) %>% 
      # Set the view to the coordinates of Philadelphia
      setView(lng = -75.1635, lat = 39.9528, zoom = 10) %>%
      # addCircleMarkers displays the point data.
      addPolylines(data = routes, color = 'red', weight = 2,
                   label = ~paste("Here be county ", lineabbr), # note the tilde / ~
                   labelOptions = labelOptions(noHide = F, direction = "top"))
  })
}

# create a call to the server and UI
shinyApp(ui, server)