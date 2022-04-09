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

###########################################################################
# Using the early bus data and the cancelled bus data, map bus performance.
###########################################################################

# from the CSVs, create point data for each stop
# from the CSVs, create point data for each early stop (bigger, clickable)
# from the CSVs, create point data for each early stop (bigger, clickable)
# from the CSVs, create point data for each bus route (bigger, clickable)


#################################################8##########################
# Load maps to the dashboard.
###########################################################################

# Using leaflet, create an image of Philadelphia and set the view. 

# Before creating the leaflet, load in the shapefile of points from github
#   loading from github enables the running of this script without necessatating
#   the downloading of anything.

https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/stops_by_route/04efe566-df96-4c1a-8824-3f92a45d0d72202047-1-11av6im.3lj8.dbf
https://github.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/stops_by_route/04efe566-df96-4c1a-8824-3f92a45d0d72202047-1-11av6im.3lj8.shp') 

library(RCurl)
movies <- read.csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/fandango/fandango_score_comparison.csv", header=TRUE)


points = sf::st_read('https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/stops_by_route/04efe566-df96-4c1a-8824-3f92a45d0d72202047-1-11av6im.3lj8.dbf') 

# The leaflet function creates the zoomable image. 
leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
  # This adds the pre-package basemap (Positron = day, DarkMatter = night)
  addProviderTiles(providers$CartoDB.DarkMatter) %>% 
  # Set the view to the coordinates of Philadelphia
  setView(lng = -75.1635, lat = 39.9528, zoom = 9)
  # addCircleMarkers displays the point data. 






