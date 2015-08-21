#!/bin/bash

HAWKULAR_URL="http://localhost:8080/hawkular/alerts"
HEADER_JSON="Content-Type: application/json"

## Send demo data on infinite loop

function send_data() {
  while true
  do
    local timestamp=$(date +%s)
    local firefox_count=$(ps -ef | grep firefox | wc -l)
    local firefox_availability="UP"
    
    if [[ firefox_count -eq 1 ]];
    then
      firefox_availability="DOWN"
    fi
    
    local data="{\"availability\":["
    data="$data {\"id\":\"firefox-process\",\"type\":\"AVAILABILITY\",\"timestamp\":$timestamp,\"value\":\"$firefox_availability\"}"
    data="$data ]}"
  
    echo "Send $data"
    
    local response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" --data "$data" $HAWKULAR_URL/data)
    if [ "$response" != "200" ]; 
    then
      echo "$response data not sent - aborting..."      
      exit 1
    fi   
    
    echo "Sleep for 2 seconds..."
    
    sleep 2
  done
}

## Main

send_data;