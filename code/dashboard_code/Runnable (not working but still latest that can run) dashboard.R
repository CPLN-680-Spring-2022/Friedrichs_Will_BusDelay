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

library(lubridate)

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



#############################################################
# Loading the all-important d-f
#############################################################

# Read all files for day 4_11
all_4_11 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/all_04_11.csv")
cancel_04_11 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/cancel_04_11.csv")
colnames(cancel_04_11) = c("a","b","c","d","e","f","g")
cancel_04_11 = cancel_04_11 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))
early_04_11 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/early_04_11.csv")
colnames(early_04_11) = c("a","b","c","d","e","f","g")
early_04_11 = early_04_11 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))

# Get names of all bus routes as character
routeNames = c("1","2","3","4","5","6","7","8","9","12","14","16","17","18",
               "19","20","21","22","23","24","25","26","27","28","29","30","31",
               "32","33","35","37","38","39","40","42","43","44","45","46","47",
               "47M","48","49","50","52","53","54","55","56","57","58","59",
               "60","61","62","64","65","66","67","68","70","73","75","77","78",
               "79","80","84","88","89","BLVDDIR","BSO","G","H","J","K","L",
               "MFO","R","XH","10","15","204","310","311","312","LUCYGO",
               "LUCYGR","11","13","34","36","36B","90","91","92","93","94","95",
               "96","97","98","99","124","127","128","129","130","131","132",
               "133","135","139","150","201","206","101","102","103","104",
               "105","106","107","108","109","110","111","112","113","114",
               "115","117","118","119","120","123","125","126")

# For each of the bus routes, make a dataframe with the following structure:
#         (where rec means recorded (i.e. no extrapolation to unrecorded stops))
#   route           day             rec_stops       rec_earl_stops      
#   rec_canc_stops  pct_earl_trips  pct_canc_trips  sum_earl_hours  
#   sum_canc_hours  avg_earl_wait   avg_canc_wait
#
# size of data frame: (routes*days_count rows, 11 columns)
days_count = 1

route_data <- data.frame(matrix(ncol = 11, nrow = (length(routeNames)*days_count)))
colname_list <- c("route", "day", "rec_stops", "rec_earl_stops",
                  "rec_canc_stops", "pct_earl_trips", "pct_canc_trips",
                  "sum_earl_hours", "sum_canc_hours", "avg_earl_wait",
                  "avg_canc_wait")
colnames(route_data) <- colname_list



for (r in 1:length(routeNames)) {
  thisroute_4_11 = filter(all_4_11, all_4_11[2] == paste("[\'",routeNames[r],"\']",sep=""))
  this_e_route_4_11 = filter(early_04_11, b ==routeNames[r])
  this_c_route_4_11 = filter(cancel_04_11, b ==routeNames[r])
  if (nrow(thisroute_4_11) != 0) {
    route_data$route[r] = routeNames[r]
    route_data$day[r] = "4_11"
    route_data$rec_stops[r] = lengths(regmatches(thisroute_4_11[,3],
                                                 gregexpr("\'", 
                                                          thisroute_4_11[,3])
    ))/2
    x = sub("-1\'","\'",thisroute_4_11[5]) 
    x = sub("-2\'","\'",x)
    x = sub("-3\'","\'",x)
    x = sub("-4\'","\'",x)
    x = sub("-5\'","\'",x)
    route_data$rec_earl_stops[r] = lengths(regmatches(x, gregexpr("-", x)))
    route_data$rec_canc_stops[r] = lengths(regmatches(x, gregexpr("999",x)))
    route_data$pct_earl_trips[r] = route_data$rec_earl_stops[r]/route_data$rec_stops[r]
    route_data$pct_canc_trips[r] = route_data$rec_canc_stops[r]/route_data$rec_stops[r]
    route_data$sum_earl_hours[r] = sum(this_e_route_4_11$g)/3600
    route_data$sum_canc_hours[r] = sum(this_c_route_4_11$g)/3600
  }
}

#############################################################

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
        fluidRow(column(width=6, leafletOutput("mymap"))),
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
  point_data <- reactive({
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
      addCircleMarkers(data = point_data(), weight = 1) # %>%
 #     addPolylines(data = routes, color = 'white', weight = 2,
 #                  label = ~paste("This is Bus Route ", lineabbr), # note the tilde / ~
 #                  labelOptions = labelOptions(noHide = F, direction = "top"))
      
  })
}

# create a call to the server and UI
shinyApp(ui, server)
