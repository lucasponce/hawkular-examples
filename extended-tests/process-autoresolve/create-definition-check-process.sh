#!/bin/bash

HAWKULAR_URL="http://localhost:8080/hawkular/alerts"
DEMO_TENANT="my-organization"

HEADER_JSON="Content-Type: application/json"
HEADER_TENANT="Hawkular-Tenant: $DEMO_TENANT"

function create_email_action() {

  ## Clean old email action

  response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/email/my-group-to-notify)

  if [ "$response" == "404" ];
  then
    echo "my-group-to-notify action is not present"
  else
    echo "deleting old my-group-to-notify action"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/email/my-group-to-notify)
  fi
  
  ## Create new email action
 
  local action="{\"actionPlugin\":\"email\","
  action="$action \"actionId\":\"my-group-to-notify\","
  action="$action \"to\":\"my-brave-admins-group@hawkular.org\","
  action="$action \"cc\":\"our-brave-cio@hawkular.org\","
  action="$action \"template.hawkular.url\":\"http://www.hawkular.org\"}"

  local response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$action" $HAWKULAR_URL/actions)

  if [ "$response" == "200" ]; 
  then
    echo "email action created"
  else
    echo "email action not created - aborting..."
    exit 1
  fi   
  
}

function create_trigger() {

  ## Clean old trigger definition
  
  local response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/check-firefox-process)
  
  if [ "$response" == "404" ];
  then
    echo "check-firefox-process trigger is not present"
  else
    echo "deleting old check-firefox-process trigger"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/check-firefox-process)
  fi  
  
  ## Create new trigger

  local trigger="{\"id\":\"check-firefox-process\","
  trigger="$trigger \"name\":\"Firefox process\","
  trigger="$trigger \"description\":\"Check availability of firefox process\","
  trigger="$trigger \"actions\":{\"email\":[\"my-group-to-notify\"]},"
  trigger="$trigger \"firingMatch\":\"ALL\","
  trigger="$trigger \"autoResolveMatch\":\"ALL\","
  trigger="$trigger \"enabled\":true,"
  trigger="$trigger \"autoDisable\":false,"
  trigger="$trigger \"autoEnable\":false,"
  trigger="$trigger \"autoResolve\":true,"
  trigger="$trigger \"autoResolveAlerts\":true,"
  trigger="$trigger \"severity\":\"HIGH\"}"

  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$trigger" $HAWKULAR_URL/triggers)
  
  if [ "$response" == "200" ]; 
  then
    echo "check-firefox-process trigger created"
  else
    echo "check-firefox-process trigger not created - aborting..."
    exit 1
  fi   
    
}

function create_conditions() {

  ## Check firefox process is down
  
  local cond1="{\"triggerMode\":\"FIRING\","
  cond1="$cond1 \"type\":\"AVAILABILITY\","
  cond1="$cond1 \"dataId\":\"firefox-process\","
  cond1="$cond1 \"operator\":\"NOT_UP\"}"

  local response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$cond1" $HAWKULAR_URL/triggers/check-firefox-process/conditions)

  if [ "$response" == "200" ]; 
  then
    echo "NOT_UP condition created"
  else
    echo "NOT_UP condition not created - aborting..."
    exit 1
  fi   
  
  ## Create a second conditions
  
  local cond2="{\"triggerMode\":\"AUTORESOLVE\","
  cond2="$cond2 \"type\":\"AVAILABILITY\","
  cond2="$cond2 \"dataId\":\"firefox-process\","
  cond2="$cond2 \"operator\":\"UP\"}"
    
  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$cond2" $HAWKULAR_URL/triggers/check-firefox-process/conditions)

  if [ "$response" == "200" ]; 
  then
    echo "UP condition created"
  else
    echo "UP condition not created - aborting..."
    exit 1
  fi   
  
}

## Main

create_email_action;
create_trigger;
create_conditions;