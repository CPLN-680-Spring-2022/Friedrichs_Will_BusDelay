library(dplyr)
library(lubridate)
options(scipen = n)
#################################################################################
# 4_11
#################################################################################

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

route_data <- data.frame(matrix(ncol = 9, nrow = (length(routeNames)*days_count)))
colname_list <- c("route", "day", "rec_stops", "rec_earl_stops",
                  "rec_canc_stops", "pct_earl_trips", "pct_canc_trips",
                  "sum_earl_hours", "sum_canc_hours")
colnames(route_data) <- colname_list



for (r in 1:length(routeNames)) {
  thisroute_4_11 = filter(all_4_11, all_4_11[2] == paste("[\'",routeNames[r],"\']",sep=""))
  this_e_route_4_11 = filter(early_04_11, b ==routeNames[r])
  this_c_route_4_11 = filter(cancel_04_11, b ==routeNames[r])
  if (nrow(thisroute_4_11) != 0) {
    route_data$route[r] = routeNames[r]
    route_data$day[r] = "4_11"
    route_data$rec_stops[r] = lengths(regmatches(thisroute_4_11[5],
                                                 gregexpr("\'", 
                                                 thisroute_4_11[5])
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

route_data_4_11 = route_data

###############################################################
#




#
#################################################################################
# 4_12
#################################################################################

# Read all files for day 4_12
all_4_12 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/all_04_12.csv")

cancel_04_12 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/cancel_04_12.csv")


colnames(cancel_04_12) = c("a","b","c","d","e","f","g")
cancel_04_12 = cancel_04_12 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))



early_04_12 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/early_04_12.csv")
colnames(early_04_12) = c("a","b","c","d","e","f","g")



early_04_12 = early_04_12 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))

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

route_data <- data.frame(matrix(ncol = 9, nrow = (length(routeNames)*days_count)))
colname_list <- c("route", "day", "rec_stops", "rec_earl_stops",
                  "rec_canc_stops", "pct_earl_trips", "pct_canc_trips",
                  "sum_earl_hours", "sum_canc_hours")
colnames(route_data) <- colname_list



for (r in 1:length(routeNames)) {
  thisroute_4_12 = filter(all_4_12, all_4_12[2] == paste("[\'",routeNames[r],"\']",sep=""))
  this_e_route_4_12 = filter(early_04_12, b ==routeNames[r])
  this_c_route_4_12 = filter(cancel_04_12, b ==routeNames[r])
  if (nrow(thisroute_4_12) != 0) {
    route_data$route[r] = routeNames[r]
    route_data$day[r] = "4_12"
    route_data$rec_stops[r] = lengths(regmatches(thisroute_4_12[5],
                                                 gregexpr("\'", 
                                                          thisroute_4_12[5])
    ))/2
    x = sub("-1\'","\'",thisroute_4_12[5]) 
    x = sub("-2\'","\'",x)
    x = sub("-3\'","\'",x)
    x = sub("-4\'","\'",x)
    x = sub("-5\'","\'",x)
    route_data$rec_earl_stops[r] = lengths(regmatches(x, gregexpr("-", x)))
    route_data$rec_canc_stops[r] = lengths(regmatches(x, gregexpr("999",x)))
    route_data$pct_earl_trips[r] = route_data$rec_earl_stops[r]/route_data$rec_stops[r]
    route_data$pct_canc_trips[r] = route_data$rec_canc_stops[r]/route_data$rec_stops[r]
    route_data$sum_earl_hours[r] = sum(this_e_route_4_12$g)/3600
    route_data$sum_canc_hours[r] = sum(this_c_route_4_12$g)/3600
  }
}

route_data_4_12 = route_data

###############################################################
#




#
#################################################################################
# 4_17
#################################################################################

# Read all files for day 4_17
all_4_17 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/all_04_17.csv")

cancel_04_17 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/cancel_04_17.csv")


colnames(cancel_04_17) = c("a","b","c","d","e","f","g")
cancel_04_17 = cancel_04_17 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))



early_04_17 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/early_04_17.csv")
colnames(early_04_17) = c("a","b","c","d","e","f","g")



early_04_17 = early_04_17 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))

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

route_data <- data.frame(matrix(ncol = 9, nrow = (length(routeNames)*days_count)))
colname_list <- c("route", "day", "rec_stops", "rec_earl_stops",
                  "rec_canc_stops", "pct_earl_trips", "pct_canc_trips",
                  "sum_earl_hours", "sum_canc_hours")
colnames(route_data) <- colname_list



for (r in 1:length(routeNames)) {
  thisroute_4_17 = filter(all_4_17, all_4_17[2] == paste("[\'",routeNames[r],"\']",sep=""))
  this_e_route_4_17 = filter(early_04_17, b ==routeNames[r])
  this_c_route_4_17 = filter(cancel_04_17, b ==routeNames[r])
  if (nrow(thisroute_4_17) != 0) {
    route_data$route[r] = routeNames[r]
    route_data$day[r] = "4_17"
    route_data$rec_stops[r] = lengths(regmatches(thisroute_4_17[5],
                                                 gregexpr("\'", 
                                                          thisroute_4_17[5])
    ))/2
    x = sub("-1\'","\'",thisroute_4_17[5]) 
    x = sub("-2\'","\'",x)
    x = sub("-3\'","\'",x)
    x = sub("-4\'","\'",x)
    x = sub("-5\'","\'",x)
    route_data$rec_earl_stops[r] = lengths(regmatches(x, gregexpr("-", x)))
    route_data$rec_canc_stops[r] = lengths(regmatches(x, gregexpr("999",x)))
    route_data$pct_earl_trips[r] = route_data$rec_earl_stops[r]/route_data$rec_stops[r]
    route_data$pct_canc_trips[r] = route_data$rec_canc_stops[r]/route_data$rec_stops[r]
    route_data$sum_earl_hours[r] = sum(this_e_route_4_17$g)/3600
    route_data$sum_canc_hours[r] = sum(this_c_route_4_17$g)/3600
  }
}

route_data_4_17 = route_data

###############################################################
#




#
#################################################################################
# 4_18
#################################################################################

# Read all files for day 4_18
all_4_18 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/all_04_18.csv")

cancel_04_18 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/cancel_04_18.csv")


colnames(cancel_04_18) = c("a","b","c","d","e","f","g")
cancel_04_18 = cancel_04_18 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))



early_04_18 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/early_04_18.csv")
colnames(early_04_18) = c("a","b","c","d","e","f","g")



early_04_18 = early_04_18 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))

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

route_data <- data.frame(matrix(ncol = 9, nrow = (length(routeNames)*days_count)))
colname_list <- c("route", "day", "rec_stops", "rec_earl_stops",
                  "rec_canc_stops", "pct_earl_trips", "pct_canc_trips",
                  "sum_earl_hours", "sum_canc_hours")
colnames(route_data) <- colname_list



for (r in 1:length(routeNames)) {
  thisroute_4_18 = filter(all_4_18, all_4_18[2] == paste("[\'",routeNames[r],"\']",sep=""))
  this_e_route_4_18 = filter(early_04_18, b ==routeNames[r])
  this_c_route_4_18 = filter(cancel_04_18, b ==routeNames[r])
  if (nrow(thisroute_4_18) != 0) {
    route_data$route[r] = routeNames[r]
    route_data$day[r] = "4_18"
    route_data$rec_stops[r] = lengths(regmatches(thisroute_4_18[5],
                                                 gregexpr("\'", 
                                                          thisroute_4_18[5])
    ))/2
    x = sub("-1\'","\'",thisroute_4_18[5]) 
    x = sub("-2\'","\'",x)
    x = sub("-3\'","\'",x)
    x = sub("-4\'","\'",x)
    x = sub("-5\'","\'",x)
    route_data$rec_earl_stops[r] = lengths(regmatches(x, gregexpr("-", x)))
    route_data$rec_canc_stops[r] = lengths(regmatches(x, gregexpr("999",x)))
    route_data$pct_earl_trips[r] = route_data$rec_earl_stops[r]/route_data$rec_stops[r]
    route_data$pct_canc_trips[r] = route_data$rec_canc_stops[r]/route_data$rec_stops[r]
    route_data$sum_earl_hours[r] = sum(this_e_route_4_18$g)/3600
    route_data$sum_canc_hours[r] = sum(this_c_route_4_18$g)/3600
  }
}

route_data_4_18 = route_data

###############################################################
#




#
#################################################################################
# 4_19
#################################################################################

# Read all files for day 4_19
all_4_19 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/all_04_19.csv")

cancel_04_19 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/cancel_04_19.csv")


colnames(cancel_04_19) = c("a","b","c","d","e","f","g")
cancel_04_19 = cancel_04_19 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))



early_04_19 <- read.csv("https://raw.githubusercontent.com/CPLN-680-Spring-2022/Friedrichs_Will_BusDelay/main/raw_data/map_data/days/early_04_19.csv")
colnames(early_04_19) = c("a","b","c","d","e","f","g")



early_04_19 = early_04_19 %>% mutate(g = period_to_seconds(hms(paste("0",g,sep = ""))))

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

route_data <- data.frame(matrix(ncol = 9, nrow = (length(routeNames)*days_count)))
colname_list <- c("route", "day", "rec_stops", "rec_earl_stops",
                  "rec_canc_stops", "pct_earl_trips", "pct_canc_trips",
                  "sum_earl_hours", "sum_canc_hours")
colnames(route_data) <- colname_list



for (r in 1:length(routeNames)) {
  thisroute_4_19 = filter(all_4_19, all_4_19[2] == paste("[\'",routeNames[r],"\']",sep=""))
  this_e_route_4_19 = filter(early_04_19, b ==routeNames[r])
  this_c_route_4_19 = filter(cancel_04_19, b ==routeNames[r])
  if (nrow(thisroute_4_19) != 0) {
    route_data$route[r] = routeNames[r]
    route_data$day[r] = "4_19"
    route_data$rec_stops[r] = lengths(regmatches(thisroute_4_19[5],
                                                 gregexpr("\'", 
                                                          thisroute_4_19[5])
    ))/2
    x = sub("-1\'","\'",thisroute_4_19[5]) 
    x = sub("-2\'","\'",x)
    x = sub("-3\'","\'",x)
    x = sub("-4\'","\'",x)
    x = sub("-5\'","\'",x)
    route_data$rec_earl_stops[r] = lengths(regmatches(x, gregexpr("-", x)))
    route_data$rec_canc_stops[r] = lengths(regmatches(x, gregexpr("999",x)))
    route_data$pct_earl_trips[r] = route_data$rec_earl_stops[r]/route_data$rec_stops[r]
    route_data$pct_canc_trips[r] = route_data$rec_canc_stops[r]/route_data$rec_stops[r]
    route_data$sum_earl_hours[r] = sum(this_e_route_4_19$g)/3600
    route_data$sum_canc_hours[r] = sum(this_c_route_4_19$g)/3600
  }
}

route_data_4_19 = route_data

###############################################################
#

# iterate through the list of bus routes
# for each route, calculate summaries by adding the values of each day.
route_sums = data.frame(matrix(ncol = 7, nrow = length(routeNames)))
rownames(route_sums) <- routeNames
colname_sums <- c("rec_stops", "rec_earl_stops",
                 "rec_canc_stops", "pct_earl_trips", "pct_canc_trips",
                 "sum_earl_hours", "sum_canc_hours")
colnames(route_sums) <- colname_sums

mega_route_data = rbind(
  route_data_4_11,
  route_data_4_12,
  route_data_4_17,
  route_data_4_18,
  route_data_4_19,
  na.rm=TRUE
)

for (r in 1:length(routeNames)) {
  specific_mega = mega_route_data %>% filter(route == routeNames[r])
  route_sums[r,1] = sum(specific_mega$rec_stops, na.rm=TRUE)
  route_sums[r,2] = sum(specific_mega$rec_earl_stops, na.rm=TRUE)    
  route_sums[r,3] = sum(specific_mega$rec_canc_stops, na.rm=TRUE) 
  route_sums[r,4] = route_sums[r,2]/route_sums[r,1]
  route_sums[r,5] = route_sums[r,3]/route_sums[r,1] 
  route_sums[r,6] = sum(specific_mega$sum_earl_hours, na.rm=TRUE)
  route_sums[r,7] = sum(specific_mega$sum_canc_hours, na.rm=TRUE)
}

route_sums = na.omit(route_sums)




# iterate through the list of the days
# for each day, calculate summaries by adding the values of each route.
day_sums = data.frame(matrix(ncol = 7, nrow = 6))
datenames = c("4-11", "4-12", "4-17", "4-18", "4-19", "Total")
rownames(day_sums) <- datenames
colnames(day_sums) <- colname_sums


for (r in 1:5) {
  specific_mega = mega_route_data %>% filter(day == gsub("-", "_", datenames[r]))
  day_sums[r,1] = sum(specific_mega$rec_stops, na.rm=TRUE)
  day_sums[r,2] = sum(specific_mega$rec_earl_stops, na.rm=TRUE)    
  day_sums[r,3] = sum(specific_mega$rec_canc_stops, na.rm=TRUE) 
  day_sums[r,4] = day_sums[r,2]/day_sums[r,1]
  day_sums[r,5] = day_sums[r,3]/day_sums[r,1] 
  day_sums[r,6] = sum(specific_mega$sum_earl_hours, na.rm=TRUE)
  day_sums[r,7] = sum(specific_mega$sum_canc_hours, na.rm=TRUE)
}

day_sums = na.omit(day_sums)

day_sums[6,1] = sum(day_sums[1,1:5])
day_sums[6,2] = sum(day_sums[2,1:5])
day_sums[6,3] = sum(day_sums[3,1:5])
day_sums[6,4] = day_sums[6,2]/day_sums[6,1]
day_sums[6,5] = day_sums[6,3]/day_sums[6,1]
day_sums[6,6] = sum(day_sums[6,1:5])
day_sums[6,7] = sum(day_sums[6,1:5])
datenames = c("4-11", "4-12", "4-17", "4-18", "4-19", "Total")
rownames(day_sums) <- datenames

write.csv(day_sums, "day_sums.csv")
write.csv(route_sums, "route_sums.csv")
write.csv(route_data_4_11, "route_data_4_11.csv")
write.csv(route_data_4_12, "route_data_4_12.csv")
write.csv(route_data_4_17, "route_data_4_17.csv")
write.csv(route_data_4_18, "route_data_4_18.csv")
write.csv(route_data_4_19, "route_data_4_19.csv")
