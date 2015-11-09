#!/bin/bash

HAWKULAR_URL="http://localhost:8080/hawkular/alerts"
DEMO_TENANT="my-organization"

HEADER_JSON="Content-Type: application/json"
HEADER_TENANT="Hawkular-Tenant: $DEMO_TENANT"

function create_email_action() {

  ## Check email plugin is installed

  local response=$(curl --write-out %{http_code} --silent --output /dev/null $HAWKULAR_URL/plugins/email)
  
  if [ "$response" == "200" ]; 
  then
    echo "email plugin installed"
  else
    echo "email plugin not present - aborting..."
    exit 1
  fi   

  ## Clean old email action

  response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/email/email-to-admin-group)

  if [ "$response" == "404" ];
  then
    echo "email-to-admin-group action is not present"
  else
    echo "deleting old email-to-admin-group action"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/email/email-to-admin-group)
  fi
  
  ## Create new email action
 
  local action="{\"actionPlugin\":\"email\","
  action="$action \"actionId\":\"email-to-admin-group\","
  action="$action \"to\":\"admin-group@hawkular.org\","
  action="$action \"cc\":\"cc-group@hawkular.org\","
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

function create_events_trigger() {

  ## Clean old trigger definition
  
  local response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/detect-undeployment-containerZ)
  
  if [ "$response" == "404" ];
  then
    echo "detect-undeployment-containerZ is not present"
  else
    echo "deleting old detect-undeployment-containerZ trigger"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/detect-undeployment-containerZ)
  fi  
  
  ## Create new trigger

  local trigger="{\"name\":\"Undeployments detection\","
  trigger="$trigger \"description\":\"Detect undeployments on containerZ\","
  trigger="$trigger \"actions\":{\"email\":[\"email-to-admin-group\"]},"
  trigger="$trigger \"firingMatch\":\"ALL\","
  trigger="$trigger \"autoResolveMatch\":\"ALL\","
  trigger="$trigger \"id\":\"detect-undeployment-containerZ\","
  trigger="$trigger \"enabled\":true,"
  trigger="$trigger \"autoDisable\":false,"
  trigger="$trigger \"autoEnable\":false,"
  trigger="$trigger \"autoResolve\":false,"
  trigger="$trigger \"autoResolveAlerts\":false,"
  trigger="$trigger \"severity\":\"HIGH\"}"

  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$trigger" $HAWKULAR_URL/triggers)
  
  if [ "$response" == "200" ]; 
  then
    echo "detect-undeployment-containerZ trigger created"
  else
    echo "detect-undeployment-containerZ trigger not created - aborting..."
    exit 1
  fi   
    
}

function create_events_conditions() {

  ## Create first condition
  
  local cond1="{\"triggerMode\":\"FIRING\","
  cond1="$cond1 \"type\":\"EVENT\","
  cond1="$cond1 \"dataId\":\"events-source\","
  cond1="$cond1 \"expression\":\"tags.operation == 'undeployment',tags.container == 'containerZ'\"}"

  local response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$cond1" $HAWKULAR_URL/triggers/detect-undeployment-containerZ/conditions)

  if [ "$response" == "200" ]; 
  then
    echo "event condition created"
  else
    echo "event condition not created - aborting..."
    exit 1
  fi   
    
}

## Main

create_email_action;
create_events_trigger;
create_events_conditions;