# NOTE: DUE TO CALENDAR SETTINGS, THIS ONLY WORKS FOR 2022. LETTING THIS RUN ACROSS A DAYLIGHT SAVINGS CHANGE WILL BREAK THIS.

# This is the second of two python scripts, with each to be run concurrently for as long as desired,
# without interruption. This python script saves .txt updates of the SEPTA TransitView Realtime Data 
# Stream (created by Part1.py) and converts their data into useful CSVs.
# A new set of CSVs is created for each day during which the program is running. 

# This script, when performing correctly, produces:
	# all_MM_DD.csv (all data of day MM/DD), by bus trip
	# cancel_MM_DD.csv (all cancellations for that day), by bus stop
	# early_MM_DD.csv (all early bus arrivals for that day), by bus stop

# Internally, the program works by constantly updating two matrices where row number represents the 6
# digit tripID. Two matrices are necessary due to complications associated with the transition between
# one day and the next, given that some bus trips run between 11:59pm and 12:01am. Data for a bus trip 
# are kept together in this situation, so the program has the ability to write to the previous day's 
# data frame if need be. 

# SEPTA's "stop_times" CSV gives one way of organizing trips by day. Its schedule extends over one day,
# but when a trip is scheduled past midnight, it is categorized into the day during which the trip started.
# It might make a stop at 25:34 rather than 01:34. 

# Organizing trips by day will be done similarly in this script.

# Load libraries
from urllib.request import Request, urlopen
from datetime import datetime, timedelta
import os
import urllib
import re
import time 
import csv
import threading

# Global variables for pathing
path = "C:/Users/wmfried-admin/Desktop/"
countsPath = "C:/Users/wmfried-admin/Desktop/Counts/"

# Create a massive matrix of lists to able to hold every possible TripID between 1-1,000,000
#   [1,000,000][9][index of list from matrix varies]
todayMatrix = [([],[],[],[],[],[],[],[],[]) for x in range(1000000)]
#   Eventual fill for the 8 columns of this matrix:
#         Trip, Route, Vehicle, [stop3,  [late,  [original_late,  [timestamp,  cancel, early
#                                stop2,   late,   original_late,   timestamp,
#                                stop1],  late],  original_late],  timestamp], 
# We will need to pull these trips given a TripID, and it is much more efficient to find by index

# Create an identical matrix to store information from the previous day if necessary.
yesterdayMatrix = [([],[],[],[],[],[],[],[],[]) for x in range(1000000)]

# Create another massive matrix of lists to able to hold every possible TripID between 1-1,000,000
#   [1,000,000][3][index of list from matrix varies]
scheduleMatrix = [([],[],[]) for x in range(1000000)]
# Read "stop_times.csv" file, one line at a time, put into a matrix:
#         Trip, [stop3, lateMode
#                stop2,  
#                stop1], 
# We will need to pull these trips given a TripID, and it is much more efficient to find by index
with open(path + "stop_times.csv", "r") as schedule:
	schedReader = csv.reader(schedule, delimiter=",")
	for i, row in enumerate(schedReader):
		# if the row is not the header:
		if (i != 0):
			tripRow = scheduleMatrix[int(row[0])]
			# Append trip if necessary (if there isn't anything for that trip yet:)
			if not tripRow[0]:
				tripRow[0].append(row[0])
			# Append stop:
			tripRow[1].append(row[3])
			# Make the final column value 1 if lateMode applies to this trip
			if int(row[3].split(":")[0]) > 20:
				tripRow[2].clear()
				tripRow[2].append(1)
			#print(scheduleMatrix[int(row[0])])
			if (scheduleMatrix[int(row[0])] == 864414):
				print("we made it????")

# Create a global variable to represent the day. This will be checked and updated periodically based
# on information from timestamps on logged SEPTA updates read by this script
monthDay = "0313" #datetime.today().strftime('%m%d')
print(monthDay)
# This is the only time it will be set by finding the actual time. 
# Each new timestamp will be compared to the datetime, and if it is a new day, monthDay changes.

# Another global variable is necessary, this one being associated with the edge-case bus trips over
# midnight issue. 
#
# This script will operate by looking at newer and newer trip updates, and logging them. After midnight,
# the program changes its day data, such that different csv files are written to. However, many of the
# trips at this point (say, 12:01am) are associated with trips that are logged into the previous day.
# Such late night trips will be marked as such, so that in a certain timeframe of timestamp(12am-4am),
# the program will log "night trips" to the previous day. 
# The global variable lateNightMode tells whether this is the case. 
lateNightMode = False
if int(datetime.today().strftime('%H')) < 9:
	lateNightMode = True

# Function to write all recorded info in one of the massive matrices (either today's or yesterday's) to "all_MM_DD.csv"
# mm_dd labels the date (for the function below and the other functions using it as an input)
# this overwrites any info already there, but the content being written will include any of the content that was already there
def write_all_csv(matrix, mm_dd):
	with open(path + "all_" + mm_dd + ".csv", 'w', newline='') as csvfile:
		myWriterAll = csv.writer(csvfile, delimiter=',')
		for row in matrix:
			if row[0]:
				myWriterAll.writerow(row)

# Function to write cancellations from one of the massive matrices (either today's or yesterday's) as rows of "cancel_MM_DD.csv"
def write_cancel_csv(matrix, mm_dd):
	with open(path + "cancel_" + mm_dd + ".csv", 'w', newline='') as csvfile:
		myWriterCancel = csv.writer(csvfile, delimiter=',')
		for row in matrix:
			if row[7]:
				if row[7][0] == 1:
					# routeLate is a list of all cancelled stops (minutes late)
					routeLate = row[4]
					# cancelledstops is the number of all cancelled stops
					cancelledStops = 0
					while "null" in routeLate: routeLate.remove("null")
					totalStops = len(routeLate)
					for i in range(totalStops):
						if routeLate[i] == "999":
							cancelledStops = cancelledStops + 1
					if (totalStops == 0): percentage = 1
					else: percentage =  cancelledStops/totalStops
					for i in range(len(routeLate)):
						if routeLate[i] == "999":
							myWriterCancel.writerow(
								[row[0][0],
								row[1][0],
								row[2][i],
								row[3][i],
								row[4][i],
								row[6][i],
								percentage])
					# Result: csv where each row is a stop such that the columns are as follows:
					#           trip, route, vehicle, stopID, lateness, timestamp, % of route stops cancelled

# Function to write early buses from one of the massive matrices (either today's or yesterday's) as rows of "early_MM_DD.csv"
def write_early_csv(matrix, mm_dd):
	with open(path + "early_" + mm_dd + ".csv", 'w', newline='') as csvfile:
		myWriterEarly = csv.writer(csvfile, delimiter=',')
		for row in matrix:
			if row[8]:
				if row[8][0] == 1:
					# routeLate is a list of all early stops (minutes late)
					routeLate = row[4]
					# cancelledstops is the number of all early stops
					earlyStops = 0
					while "null" in routeLate: routeLate.remove("null")
					totalStops = len(routeLate)
					for i in range(totalStops):
						if int(routeLate[i]) < 0:
							earlyStops = earlyStops + 1
					if (totalStops == 0): percentage = 1
					else: percentage =  earlyStops/totalStops
					for i in range(len(routeLate)):
						if int(routeLate[i]) < 0:
							myWriterEarly.writerow(
								[row[0][0],
								row[1][0],
								row[2][i],
								row[3][i],
								row[4][i],
								row[6][i],
								percentage])
					# Result: csv where each row is a stop such that the columns are as follows:
					#           trip, route, vehicle, stopID, lateness, timestamp, % of route stops early 
def write_everything():
	global monthDay
	today = datetime.strptime(str(monthDay) + "2022",'%m%d%Y')
	yesterday = today-timedelta(1)
	to_day = today.strftime('%m_%d')
	yester_day = yesterday.strftime('%m_%d')
	# Write all recorded info to "all_MM_DD.csv" for yesterday
	write_all_csv(yesterdayMatrix, yester_day)
	# Write all cancellations as rows of "cancel_MM_DD.csv" for yesterday
	write_cancel_csv(yesterdayMatrix, yester_day)
	# Write all early buses as rows of "early_MM_DD.csv" for yesterday
	write_early_csv(yesterdayMatrix, yester_day)

	# Write all recorded info to "all_MM_DD.csv" for today
	write_all_csv(todayMatrix, to_day)
	# Write all cancellations as rows of "cancel_MM_DD.csv" for today
	write_cancel_csv(todayMatrix, to_day)
	# Write all early buses as rows of "early_MM_DD.csv" for today
	write_early_csv(todayMatrix, to_day)
						  
# Wait two minutes before running this again
# your code
stop = time.time()



# This function logs the data into internal dataframes, given a string with SEPTA bus updates (full)
# The function writes to CSVs if boolean "writeMoment" is True
def string_to_write(full, writeMoment):
	global monthDay
	global lateNightMode
	global yesterdayMatrix
	global todayMatrix
	# Make the file's single line into a string called "full"
	# Take the oldest string from the SEPTA trip updates
	# Divide that string into list of *routes* with information for each
	# Eliminate the first 10 and last 1 character(s) from that string, separate by _],_
	iterateFull = full[12:-1].split("],")
	#############################################################
	# ITERATE THROUGH ALL ROUTES THAT ARE LOGGED WITH THE UPDATE
	#############################################################
	for routeText in iterateFull:
		# Set a variable _routeVar_ to the route number
		# Save the route we are on before iterating though trips of that route
		routeVar = routeText.split(':')[0].replace('\"','')
		# Break up _routeText_ into *trips*, iterate through them
		iterateRouteText = routeText.split(':[{')[1].split('{')
		for tripText in iterateRouteText:
			# Get from text: trip, route, vehicle, stop, "late", "original_late", timestamp, cancel
			trip = int(tripText.split("\"trip\":")[1].split(',')[0].replace('\"',''))
			vehicle = tripText.split("\"VehicleID\":")[1].split(',')[0].replace('\"','')
			stop = tripText.split("\"next_stop_id\":")[1].split(',')[0].replace('\"','')
			late = tripText.split("\"late\":")[1].split(',')[0].replace('\"','')
			original_late = tripText.split("\"original_late\":")[1].split(',')[0].replace('\"','')
			timestamp = int(tripText.split("\"timestamp\":")[1].split('}')[0])
			# Aside: Since the timestamp is available, check to see if it warrants updating the monthDay
			# No timestamp should be looked at by the program out of order, but if somehow this does occur, it will
			# be dealt with
			print(datetime.fromtimestamp(timestamp).strftime('%H:%M:%S %m%d'))
			if int(datetime.fromtimestamp(timestamp).strftime('%m%d')) < int(monthDay):
				print(" ")
				print("______________________")
				print("Here is the issue. We have moved on to the day " + str(monthDay) + ".") 
				print("even so, the timestamp of the most recently accessed day is " + str(datetime.fromtimestamp(timestamp).strftime('%m%d')) + ".")
				print("______________________")
				print(" ")
			if int(datetime.fromtimestamp(timestamp).strftime('%m%d')) > int(monthDay):
				# If the new timestamp comes from a new day, begin lateNightMode and update monthDay
				print("Now we have changed the TIMESTAMP.")
				lateNightMode = True
				monthDay = datetime.fromtimestamp(timestamp).strftime('%m%d')
				# conduct an impromptu write_everything
				write_everything()
				# yesterdayMatrix gets lost, todayMatrix becomes yesterdayMatrix
				yesterdayMatrix = todayMatrix
				todayMatrix = [([],[],[],[],[],[],[],[],[]) for x in range(1000000)]
			# If lateNightMode is true, check to see if the timestamp means lateNightMode should be turned off
			#   (is it 7am yet?)
			if int(datetime.fromtimestamp(timestamp).strftime('%H')) > 8 and lateNightMode == True:
				lateNightMode = False

			# Back to writing to internal datasets: if no trips of that name have been entered, fill all values
			#  respective columns 
			# If it is lateNightMode, and the specific trip in question is one that could is operated in the late night,
			# write to the previous day's matrix 
			if scheduleMatrix[trip][2] == [1] and lateNightMode == True:   
				tripRow = yesterdayMatrix[int(trip)]
			else: 
				tripRow = todayMatrix[int(trip)]
			if not tripRow[0]:
				# Fill into the matrix: trip, route, vehicle, stop, "late", "original_late", timestamp, cancel, late
				tripRow[0].append(trip)
				tripRow[1].append(routeVar)
				tripRow[2].append(vehicle) 
				tripRow[3].append(stop)
				tripRow[4].append(late)
				tripRow[5].append(original_late)
				tripRow[6].append(timestamp)
				# Whether cancelled:
				if (int(tripRow[4][-1]) == 999):
					tripRow[7].clear()
					tripRow[7].append(1)
				# Whether late (binary):
				if (int(tripRow[4][-1]) < 0):
					tripRow[8].clear()
					tripRow[8].append(1)
			# If a trip of that name has already been entered:

			#  or original_late, then update stop, late, original_late, timestamp, and cancel
			else:   
				# If there the stop is the same, and the late/original_late has changed, update those and
				#   check for cancellation 
				if tripRow[3][-1] == stop and tripRow[4][-1] != late:
					tripRow[4].pop()
					tripRow[4].append(late)
					tripRow[5].pop()
					tripRow[5].append(original_late)
					tripRow[6].pop()
					tripRow[6].append(timestamp)
				# If the stop is not the same, append new information without popping and check for cancellation
				elif tripRow[3][-1] != stop:
					# Vehicle, stop, late, original_late, timestamp, cancel, late(binary)
					tripRow[2].append(vehicle) 
					tripRow[3].append(stop)
					tripRow[4].append(late)
					tripRow[5].append(original_late)
					tripRow[6].append(timestamp)
					# Whether cancelled
					if (int(tripRow[4][-1]) == 999):
						tripRow[7].clear()
						tripRow[7].append(1)
					# Whether late (binary)
					if (int(tripRow[4][-1]) < 0):
						tripRow[8].clear()
						tripRow[8].append(1)
				# Otherwise, just update the timestamp
				else:
					tripRow[6].pop()
					tripRow[6].append(timestamp)
	if writeMoment:
		write_everything()

	stop = time.time()


# Temporary: DO THIS (21900) TIMES - if every time is 2 mins, this means a month's worth of data
i = 0
writeMoment = False
value = True
while value:
	i = i + 1
	# If the directory of SEPTA update-turned-.txt is not empty:
	if len(os.listdir(countsPath)) > 0:
		start = time.time()
		# Get the oldest file in it and try to access its information
		oldest_file = min(os.listdir(countsPath), 
					  key=lambda p: os.path.getctime(os.path.join(countsPath, p)))
		try:
			with open((countsPath + oldest_file), 'r') as f:
				full = f.read()
				f.close()
			if full == "":
				print("Empty update, leaving this for now.")
			else:
				print("Reading " + oldest_file + " now.")
				print(oldest_file)
				string_to_write(full, writeMoment)
				print("Writing to internal files.")
				print("Removing " + oldest_file + " now.")
				os.remove(countsPath + oldest_file)
			if i%10 == 0:
				writeMoment = True
				print("Writing externally")

		except PermissionError:
			print("Error in permissions, trying a different .txt to read.")
		

#C:/Users_/Administrator/Desktop/raw_data/Mar12
#C:/Users_/wmfried-admin/Desktop

