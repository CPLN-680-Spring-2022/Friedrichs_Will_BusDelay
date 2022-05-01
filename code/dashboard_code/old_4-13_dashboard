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

library(dplyr)

numpoints = st_read('https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/stops_by_route/routestops.dbf') 
numpoints = st_as_sf(numpoints,  coords = c("Lon", "Lat"))

numpoints$StopId<-as.character(numpoints$StopId)

early_04_11 = read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/early_04_11.csv")
colnames(early_04_11) = c("tripID", "route", "x1","StopId","x2","timestamp","x3")
early_04_11 = early_04_11 %>% na.omit() %>% select(c("tripID", "route", "StopId", "timestamp"))
early_04_11 = early_04_11[!early_04_11$StopId == "null", ] 

early_04_11join = merge(numpoints, early_04_11, "StopId")



cancel_04_11 = read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/cancel_04_11.csv")
colnames(cancel_04_11) = c("tripID", "route", "x1","StopId","x2","timestamp","x3")
cancel_04_11 = cancel_04_11 %>% na.omit() %>% select(c("tripID", "route", "StopId", "timestamp"))
cancel_04_11 = cancel_04_11[!cancel_04_11$StopId == "null", ] 

cancel_04_11join = merge(numpoints, cancel_04_11, "StopId")



early_04_13 = read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/early_04_13.csv")
colnames(early_04_13) = c("tripID", "route", "x1","StopId","x2","timestamp","x3")
early_04_13 = early_04_13 %>% na.omit() %>% select(c("tripID", "route", "StopId", "timestamp"))
early_04_13 = early_04_13[!early_04_13$StopId == "null", ] 

early_04_13join = merge(numpoints, early_04_13, "StopId")



cancel_04_13 = read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/cancel_04_13.csv")
colnames(cancel_04_13) = c("tripID", "route", "x1","StopId","x2","timestamp","x3")
cancel_04_13 = cancel_04_13 %>% na.omit() %>% select(c("tripID", "route", "StopId", "timestamp"))
cancel_04_13 = cancel_04_13[!cancel_04_13$StopId == "null", ] 

cancel_04_13join = merge(numpoints, cancel_04_13, "StopId")

# early_04_11 = read.csv("early_04_11.csv")
# cancel_04_11 = read.csv("cancel_04_11.csv")
# early_04_12 = read.csv("early_04_11.csv")
# cancel_04_12 = read.csv("cancel_04_11.csv")
# early_04_13 = read.csv("early_04_11.csv")
# cancel_04_13 = read.csv("cancel_04_11.csv")

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


s = routes
bap = head(routes)
s

checkmarkcode = "here"
# eval(parse( text=checkmarkcode )),
# checkboxInput("somevalue", "Some value", FALSE)


xabbr = routes$lineabbr

percent1 = q
percent2 = q
percent3 = q

percentlogged = q

route1 = q
route2 = q
route3 = q

routelogged = q

ui <- navbarPage("SEPTA Bus Reliability Tracker",
  tabPanel("Summary Statistics",
    sidebarLayout(
      sidebarPanel(
        fluidRow(
          column(width=4, 
                 selectInput(inputId = "since_on", label = "", choices = c("Since","On  ")),
                 selected = "plot"),
          column(width=6, 
                 selectInput(inputId = "date", label = "", choices = c("April 13, 2022",
                                                                         "April 12, 2022",
                                                                         "April 11, 2022")),
                 selected = "plot")
        )
      ),
      mainPanel(
        style = "font-size:20px;",
        #strong("Since October 21, 2015:\n "),
        p(span("NA%", style = "color:blue"),
          "of scheduled SEPTA stops have been \"ghosted\"."),
        p(span("NA%", style = "color:blue"),
          "of scheduled SEPTA stops have been 5 or more minutes early."),
        p(span("NA%", style = "color:blue"),
          "of scheduled SEPTA stops have been 10 or more minutes late."),
        p("\n"),
        p(span("Route NA", style = "color:blue"),
          "is the route with the most \"ghosted\" stops."),
        p(span("Route nA", style = "color:blue"),
          "is the route most frequently 5 or more minutes early."),
        p(span("Route NA", style = "color:blue"),
          "is the route most frequently 10 or more minutes late.")
      )
    )
  ),
  tabPanel("Map",
    sidebarLayout(
      sidebarPanel(
        fluidRow(
          column(width=4, 
                 selectInput(inputId = "since_on2", label = "", choices = c("Since","On  ")),
                 selected = "plot"),
          column(width=6, 
                 selectInput(inputId = "date2", label = "", choices = c("April 13, 2022",
                                                                        "April 12, 2022",
                                                                        "April 11, 2022")),
                 selected = "plot")
        ),
        fluidRow(
        actionLink("selectall","Select All") 
        ),
        fluidRow(
          column(
            width = 3,
            checkboxGroupInput(
              inputId = "checka",
              label = NULL,
              choices = xabbr[1:35]
            )
          ),

          column(
            width = 3,
            checkboxGroupInput(
              inputId = "checkb",
              label = NULL,
              choices = xabbr[36:70]
            )
          ),

          column(
            width = 3,
            checkboxGroupInput(
              inputId = "checkc",
              label = NULL,
              choices = xabbr[71:105]
            )
          ),

          column(
            width = 3,
            checkboxGroupInput(
              inputId = "checkd",
              label = NULL,
              choices = xabbr[106:140]
            )
          )
        )
      ),
      mainPanel(
        fluidRow(column(width=12, leafletOutput("mymap"))),
        fluidRow(
        column(width=4, 
               selectInput(inputId = "SPANOO",label = "SEPTA Bus Network in Greater Philadelphia Region", choices = c("Early Arrivals","Cancellations")),
               selected = "plot")
        )
      )
    )
  )
)



server <- function(input, output, session) {
  observe({
    if(input$selectall == 0) return(NULL)
    else if (input$selectall%%2 == 0)
    {
      updateCheckboxGroupInput(session,"checka","",choices=xabbr[1:35])
      updateCheckboxGroupInput(session,"checkb","",choices=xabbr[36:70])
      updateCheckboxGroupInput(session,"checkc","",choices=xabbr[71:105])
      updateCheckboxGroupInput(session,"checkd","",choices=xabbr[106:140])
    }
    else
    {
      updateCheckboxGroupInput(session,"checka","",choices=xabbr[1:35],selected=xabbr[1:35])
      updateCheckboxGroupInput(session,"checkb","",choices=xabbr[36:70],selected=xabbr[36:70])
      updateCheckboxGroupInput(session,"checkc","",choices=xabbr[71:105],selected=xabbr[71:105])
      updateCheckboxGroupInput(session,"checkd","",choices=xabbr[106:140],selected=xabbr[106:140])
    }
  })
  map_data <- reactive({
    point_data = s
    if (input$"date" == "April 11, 2022") {
      if (input$"SPANOO" == "Early Arrivals") {
        point_data = early_04_11join
      }
      else {
        point_data = cancel_04_11join
      }
    }
    else {
      if (input$"SPANOO" == "Early Arrivals") {
        point_data = early_04_13join
      }
      else {
        point_data = cancel_04_13join
      }
    }
    return(point_data)
  })
  percentlogged_ghosted <- reactive({
    return("NA")
  })
  percentlogged_early <- reactive({
    return("NA")
  })
  percentlogged_late <- reactive({
    return("NA")
  })
  most_ghosted <- reactive({
    return("NA")
  })
  most_early <- reactive({
    return("NA")
  })
  most_late <- reactive({
    return("NA")
  })
  
  # if (input$"since_on" == "On  "){
  #   if (input$"date" == "April 11, 2022"){
  #     routelogged = "23"
  #   }
  #   if (input$"date" == "April 12, 2022"){
  #     routelogged = "19"
  #   }
  #   else {
  #     routelogged = "5"
  #   }
  # }
  # if (input$"since_on" == "Since"){
  #   if (input$"date" == "April 11, 2022"){
  #     routelogged = "A"
  #   }
  #   if (input$"date" == "April 12, 2022"){
  #     routelogged = "B"
  #   }
  #   else {
  #     routelogged = "C"
  #   }
  # }
  # 
  # 
  output$mymap <- renderLeaflet({
    # The leaflet function creates the zoomable image. 
    leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
      # This adds the pre-package basemap (Positron = day, DarkMatter = night)
      addProviderTiles(providers$CartoDB.DarkMatter) %>% 
      # Set the view to the coordinates of Philadelphia
      setView(lng = -75.1635, lat = 39.9528, zoom = 10) %>%
      # addCircleMarkers displays the point data.
      addPolygons(data = point_data()) %>%
      addPolylines(data = routes, color = 'white', weight = 2,
                   label = ~paste("Here be county ", lineabbr), # note the tilde / ~
                   labelOptions = labelOptions(noHide = F, direction = "top"))
  })
}

# create a call to the server and UI
shinyApp(ui, server)
