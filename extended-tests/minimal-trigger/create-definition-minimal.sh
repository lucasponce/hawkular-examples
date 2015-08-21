#!/bin/bash

HAWKULAR_URL="http://localhost:8080/hawkular/alerts"
DEMO_TENANT="my-organization"

HEADER_ACCEPT="Accept: application/json"
HEADER_CONTENT="Content-Type: application/json"
HEADER_TENANT="Hawkular-Tenant: $DEMO_TENANT"

function create_minimal_trigger() {
  
  ## Create new trigger

  local trigger="{}"
  
  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_CONTENT" -H "$HEADER_ACCEPT" -H "$HEADER_TENANT" --data "$trigger" $HAWKULAR_URL/triggers)
  
  if [ "$response" == "200" ]; 
  then
    echo "minimal trigger created"
  else
    echo "minimal trigger not created - aborting..."
    exit 1
  fi   
    
}

## Main

create_minimal_trigger;