# This python script saves the SEPTA TransitView Realtime Data Stream to a CSV
# Each row is information associated with a bus trip in the SEPTA network

# Load libraries
from urllib.request import Request, urlopen
import urllib
import re
import time 
import csv

# Create a massive matrix of lists to able to hold every possible TripID between 1-1,000,000
#   [1,000,000][8][index of list from matrix varies]
fullMatrix = [([],[],[],[],[],[],[],[]) for x in range(1000000)]
#   Eventual fill for the 8 columns of this matrix:
#         Trip, Route, Vehicle, [stop3,  [late,  [original_late,  [timestamp,  cancel
#                                stop2,   late,   original_late,   timestamp,
#                                stop1],  late],  original_late],  timestamp], 
# We will need to pull these trips given a TripID, and it is much more efficient to find by index

# Temporary: DO THIS 10 TIMES
for i in range(0, 60):
    # Set file variable to equal SEPTA TransitView Realtime Data Stream link
    url = "https://www3.septa.org/api/TransitViewAll/"
    file = urllib.request.urlopen(url)

    # Make the file's single line into a string called "full"
    full = ""
    for line in file:
        decoded_line = line.decode("utf-8")
        full = decoded_line

    # Divide _full_ into list of *routes* with information for each
    # Eliminate the first 10 and last 1 character(s) from _full_, separate by _],_
    iterateFull = full[12:-1].split("],")
    # Iterate through the routes
    for routeText in iterateFull:
        # Set a variable _routeVar_ to the route number
        # Save the route we are on before iterating though trips of that route
        routeVar = routeText.split(':')[0].replace('\"','')
        # Break up _routeText_ into *trips*, iterate through them
        iterateRouteText = routeText.split(':[{')[1].split('{')
        for tripText in iterateRouteText:
            # Get trip
            trip = tripText.split("\"trip\":")[1].split(',')[0].replace('\"','')
            # If no trips of that name have been entered, fill all values
            #  respective columns 
            tripRow = fullMatrix[int(trip)]
            if not tripRow[0]:
                # Trip:
                tripRow[0].append(trip)
                # Route:
                tripRow[1].append(routeVar)
                # Vehicle:
                tripRow[2].append(tripText.split("\"VehicleID\":")[1].split(',')[0].replace('\"','')) 
                # stop:
                tripRow[3].append(tripText.split("\"next_stop_id\":")[1].split(',')[0].replace('\"',''))
                # late:
                tripRow[4].append(tripText.split("\"late\":")[1].split(',')[0].replace('\"',''))
                # original_late:
                tripRow[5].append(tripText.split("\"original_late\":")[1].split(',')[0].replace('\"',''))
                # timestamp:
                tripRow[6].append(tripText.split("\"timestamp\":")[1].split('}')[0])
                # cancel:
                if int(tripRow[4][-1]) == 999 | int(tripRow[5][-1]) == 999:
                    tripRow[7].clear()
                    tripRow[7].append(1)
            # If a trip of that name has already been entered:

            #  or original_late, then update stop, late, original_late, timestamp, and cancel
            else:   
                # If there the stop is the same, and the late/original_late has changed, update those and
                #   check for cancellation 
                if (
                    tripRow[3][-1] == 
                        tripText.split("\"next_stop_id\":")[1].split(',')[0].replace('\"','') 
                    and tripRow[4][-1] != 
                        tripText.split("\"late\":")[1].split(',')[0].replace('\"','')
                ):
                    tripRow[4].pop()
                    tripRow[4].append(tripText.split("\"late\":")[1].split(',')[0].replace('\"',''))
                    tripRow[5].pop()
                    tripRow[5].append(tripText.split("\"original_late\":")[1].split(',')[0].replace('\"',''))
                    tripRow[6].pop()
                    tripRow[6].append(tripText.split("\"timestamp\":")[1].split('}')[0])
                # If the stop is not the same, append new information without popping and check for cancellation
                elif (
                    tripRow[3][-1] != 
                        tripText.split("\"next_stop_id\":")[1].split(',')[0].replace('\"','') 
                ):
                    # Vehicle:
                    tripRow[2].append(tripText.split("\"VehicleID\":")[1].split(',')[0].replace('\"','')) 
                    # stop:
                    tripRow[3].append(tripText.split("\"next_stop_id\":")[1].split(',')[0].replace('\"',''))
                    # late:
                    tripRow[4].append(tripText.split("\"late\":")[1].split(',')[0].replace('\"',''))
                    # original_late:
                    tripRow[5].append(tripText.split("\"original_late\":")[1].split(',')[0].replace('\"',''))
                    # timestamp:
                    tripRow[6].append(tripText.split("\"timestamp\":")[1].split('}')[0])
                    if int(tripRow[4][-1]) == 999 | int(tripRow[5][-1]) == 999:
                        tripRow[7].clear()
                        tripRow[7].append(1)
                # Otherwise, just update the timestamp
                else:
                    tripRow[6].pop()
                    tripRow[6].append(tripText.split("\"timestamp\":")[1].split('}')[0])
    # Wait two minutes before running this again
    time.sleep(120)

# Write to a csv
with open('C:/Users/willf/Desktop/all.csv', 'w', newline='') as csvfile:
    mywriter = csv.writer(csvfile, delimiter=',')
    for row in fullMatrix:
        if row[0]:
            mywriter.writerow(row)

