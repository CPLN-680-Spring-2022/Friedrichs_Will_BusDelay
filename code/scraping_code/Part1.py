# This is the first of two python scripts, with each to be run concurrently
# This one constantly loads info from SEPTA saves each section of info as a .txt file.

# Load libraries
from urllib.request import Request, urlopen
from queue import Queue
import urllib
import time 

# Set file variable to equal SEPTA TransitView Realtime Data Stream link
url = "https://www3.septa.org/api/TransitViewAll/"

# Read from SEPTA's real time info URL
# If that URL has a changed timestamp from the previously read one, use that
def read_from_url(oldtime):
    file = urllib.request.urlopen(url)
    full = ""
    for line in file:
        decoded_line = line.decode("utf-8")
        full = decoded_line
    newtime = int(full.split("\"timestamp\":")[1].split('}')[0])
    if newtime > oldtime:
        update_name = "C:/Users/wmfried-admin/Desktop/Counts/"+str(newtime)+".txt"
        with open(update_name, 'w') as f:
            f.write(full)
            f.close()
        return newtime
    else:
        return oldtime

# In a forever loop, try to download a new .txt every two seconds
value = True
x = 0
while (value):
    x = read_from_url(x)
    time.sleep(2)



#C:/Users_/Administrator/Desktop/raw_data/Mar12/
#C:/Users_/wmfried-admin/Desktop
