# README for CPLN 680

City bus operations in Philadelphia have a variety of issues, but this report focuses specifically on two of them: i) buses arriving to and departing from stops early, and ii) buses that are cancelled in real-time, within hours of their original scheduled departure times. The scope of both issues may be examined by tracking data associated with all early bus departures and cancellations.

This github repository contains the following folders:

archive - A resting place for files no longer important to the project

code - A folder to organize runnable python and r scripts
        scraping_code - to organize code for scraping SEPTA real-time updates and making CSVs
            Part1.py - a script to get all updates as txt files from SEPTA's updates in real time
            (this one is run on an Amazon AWS EC2 server, and daily results are collected manually from there)
            Part2.py - a script to get all txt files into CSV outputs for use in the dashboard and for research
        dashboard_code - to organize code for turning CSVs into a dashboard
            dashboard_code - code to create dashboard
            dashboard_code_yt_example - example code to mess around with dashboard creation
        planning_steps - a place to for .txt documents to think through the project
        presentations_and_writeups - a place for ppt presentations and docx writeups
        raw_data - a place for scraped data and dashboard map data
            scrape_data
                stop_times.csv - a document used in Part2, mapping the scheduled stop times for all SEPTA routes
            map_data - includes shapefiles of all bus stops and bus routes, and other pieces to make the dashboard map visuals
        Instances - EC2 Management Console - a link to the AWS EC2 Server