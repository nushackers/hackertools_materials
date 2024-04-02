#!/bin/bash

# The URL to fetch data from
URL="http://datamall2.mytransport.sg/ltaodataservice/TrafficIncidents"
ACCOUNT_KEY="Enter your key"

# The location to save the fetched data
OUTPUT_FILE="/path/to/traffic_incidents_$(date +'%Y-%m-%d_%H%M%S').json"

# Use curl to fetch data, including the AccountKey in the header for authorization
curl -X GET "$URL" -H "accept: application/json" -H "AccountKey: ${ACCOUNT_KEY}" -o "$OUTPUT_FILE"

