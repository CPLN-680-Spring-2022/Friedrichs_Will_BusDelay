# Load libraries
import csv

# Create a massive matrix of lists to able to hold every possible TripID between 1-1,000,000
#   [1,000,000][8][index of list from matrix varies]
fullMatrix = [([],[],[]) for x in range(1000000)]
#   Eventual fill for the 3 columns of this matrix:
#         Route, [stop3, [timestamp,
#                 stop2,  timestamp,
#                 stop1], timestamp]
# We will need to pull these trips given a TripID, and it is much more efficient to find by index

# Read "stop_times.csv" file, one line at a time
with open("C:/Users/willf/Desktop/CPLN_680_Adv_Topics_in_GIS/local_repo_680/raw_data/stop_times.csv", "r") as stops:
    reader = csv.reader(stops, delimiter=",")
    for i, row in enumerate(reader):
        # if the row is not the header:
        if (i != 0):
            tripRow = fullMatrix[int(row[0])]
            # Append route if necessary
            if not tripRow[0]:
                tripRow[0].append(row[0])
            # Append stop:
            tripRow[1].append(row[3])
            # Append timestamp:
            tripRow[2].append(row[4])

# Write to a csv
with open('C:/Users/willf/Desktop/ball.csv', 'w', newline='') as csvfile:
    mywriter = csv.writer(csvfile, delimiter=',')
    for row in fullMatrix:
        if row[0]:
            mywriter.writerow(row)

# Open CSV with collected trips
with open("C:/Users/willf/Desktop/CPLN_680_Adv_Topics_in_GIS/local_repo_680/raw_data/all.csv", "r") as all:
    reader = csv.reader(all, delimiter=",")
    # Write to a csv
    with open('C:/Users/willf/Desktop/output.csv', 'w', newline='') as csvfile:
        mywriter = csv.writer(csvfile, delimiter=',')
        for i, row in enumerate(reader):
            # If a trip has had a cancelation:
            if row[7].replace('[',"").replace(']',"") == "1":
                # create a copy of the GTFS list of stops on that route
                routeLate = row[4].replace('[',"").replace(']',"").replace('\'',"").split(',')
                routeStop = row[3].replace('[',"").replace(']',"").replace('\'',"").split(',')
                # stops will be eliminated from this list if they were reached before trip cancelation
                for i in range(len(routeLate)):
                    if routeLate[i] != "999":
                        while routeLate[i] in routeStop: routeStop.remove(routeLate[i])
                while "null" in routeStop: routeStop.remove("null")
                # result will be missed stops for every cancelled trip: csv with...
                #   Trip, Route, Vehicle, stop,  late,   timestamp
                for i in range(len(routeStop)):
                    mywriter.writerow(
                        [row[0].replace('[',"").replace(']',"").replace('\'',""),
                        row[1].replace('[',"").replace(']',"").replace('\'',""),
                        row[2].replace('[',"").replace(']',"").replace('\'',"").split(',')[i],
                        row[3].replace('[',"").replace(']',"").replace('\'',"").split(',')[i],
                        row[4].replace('[',"").replace(']',"").replace('\'',"").split(',')[i],
                        row[6].replace('[',"").replace(']',"").replace('\'',"").split(',')[i]])
# result will be missed stops for every cancelled trip: csv with...
#   Trip, Route, Vehicle, stop,  late,  original_late,  timestamp
