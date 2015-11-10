#!/bin/bash

HAWKULAR_URL="http://localhost:8080/hawkular/alerts"
HEADER_JSON="Content-Type: application/json"

## Send demo data on infinite loop

function send_data() {
  while true
  do
    local timestamp=$(date +%s)
    local valuex=$(shuf -i1-10 -n1)
    local valuey=$(shuf -i1-10 -n1)
    local data="["
    data="$data {\"id\":\"data-x\",\"timestamp\":$timestamp,\"value\":\"$valuex\"},"
    data="$data {\"id\":\"data-y\",\"timestamp\":$timestamp,\"value\":\"$valuey\"}"
    data="$data ]"
  
    echo "Send $data"
    
    local response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" --data "$data" $HAWKULAR_URL/data)
    if [ "$response" != "200" ]; 
    then
      echo "$response data not sent - aborting..."      
      exit 1
    fi   
    
    sleep 0.5
  done
}

## Main

send_data;
