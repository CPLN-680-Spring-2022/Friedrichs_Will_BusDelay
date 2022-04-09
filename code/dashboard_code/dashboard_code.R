# dashboard code: simple dashboard example
# Dashboard basics: https://www.youtube.com/watch?v=41jmGq7ALMY&ab_channel=Appsilon
# Interactive map dashboard: https://byollin.github.io/ShinyLeaflet/#25

# libraries necessary

# an R package that makes it easy to build interactive web apps straight from R
library(shiny)
# a library that makes it easy to use Shiny to create dashboards
library(shinydashboard)
# an open source JavaScript library used to build web mapping applications
library(leaflet)

library(sf)

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

# Using leaflet, create an image of Philadelphia and set the view. 

# Before creating the leaflet, load in the shapefile of points from github
#   loading from github enables the running of this script without necessatating
#   the downloading of anything.

points = st_read('https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/stops_by_route/routestops.dbf') 
points = st_as_sf(points,  coords = c("Lon", "Lat"))

routes = st_read('https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/polyline_routes/routes.dbf') 
routes = st_as_sf(routes,  coords = c("Lon", "Lat"))

# The leaflet function creates the zoomable image. 
leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
  # This adds the pre-package basemap (Positron = day, DarkMatter = night)
  addProviderTiles(providers$CartoDB.DarkMatter) %>% 
  # Set the view to the coordinates of Philadelphia
  setView(lng = -75.1635, lat = 39.9528, zoom = 10) %>%
  # addCircleMarkers displays the point data. 
  addCircleMarkers(data = points, fillColor = 'gray', fillOpacity = 0.1, stroke = FALSE,
                   radius = 1.3)







