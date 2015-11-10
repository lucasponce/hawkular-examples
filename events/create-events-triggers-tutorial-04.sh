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

function create_first_trigger_and_conditions() {

  ## Clean old trigger definition
  
  local response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/detect-undeployment-containerZ-with-errors)
  
  if [ "$response" == "404" ];
  then
    echo "detect-undeployment-containerZ-with-errors is not present"
  else
    echo "deleting old detect-undeployment-containerZ-with-errors trigger"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/detect-undeployment-containerZ-with-errors)
  fi  
  
  ## Create new trigger

  local trigger="{\"name\":\"Undeployments detection with Errors\","
  trigger="$trigger \"description\":\"Detect undeployments on containerZ with log errors\","
  trigger="$trigger \"firingMatch\":\"ALL\","
  trigger="$trigger \"autoResolveMatch\":\"ALL\","
  trigger="$trigger \"id\":\"detect-undeployment-containerZ-with-errors\","
  trigger="$trigger \"enabled\":true,"
  trigger="$trigger \"autoDisable\":false,"
  trigger="$trigger \"autoEnable\":false,"
  trigger="$trigger \"autoResolve\":false,"
  trigger="$trigger \"autoResolveAlerts\":false,"
  trigger="$trigger \"severity\":\"HIGH\"}"

  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$trigger" $HAWKULAR_URL/triggers)
  
  if [ "$response" == "200" ]; 
  then
    echo "detect-undeployment-containerZ-with-errors trigger created"
  else
    echo "detect-undeployment-containerZ-with-errors trigger not created - aborting..."
    exit 1
  fi   

  ## Create first condition  
  
  local conditions="[{\"triggerMode\":\"FIRING\","
  conditions="$conditions \"type\":\"EVENT\","
  conditions="$conditions \"dataId\":\"events-deployments-source\","
  conditions="$conditions \"expression\":\"tags.operation == 'undeployment',tags.container == 'containerZ'\"},"
  conditions="$conditions {\"triggerMode\":\"FIRING\","
  conditions="$conditions \"type\":\"EVENT\","
  conditions="$conditions \"dataId\":\"events-logs-source\","
  conditions="$conditions \"expression\":\"text starts 'ERROR'\"}]"
  
  local response=$(curl -X PUT --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" \
  --data "$conditions" $HAWKULAR_URL/triggers/detect-undeployment-containerZ-with-errors/conditions/FIRING)

  if [ "$response" == "200" ]; 
  then
    echo "event conditions created"
  else
    echo "event conditions not created - aborting..."
    exit 1
  fi   
    
}

function create_chained_trigger() {

  ## Clean old trigger definition
  
  local response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/chained-trigger)
  
  if [ "$response" == "404" ];
  then
    echo "chained-trigger is not present"
  else
    echo "deleting old chained-trigger trigger"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/chained-trigger)
  fi  
  
  ## Create new trigger

  local trigger="{\"name\":\"Chained trigger\","
  trigger="$trigger \"description\":\"Show how to define a trigger using Events generated from other trigger\","
  trigger="$trigger \"actions\":{\"email\":[\"email-to-admin-group\"]},"
  trigger="$trigger \"firingMatch\":\"ALL\","
  trigger="$trigger \"autoResolveMatch\":\"ALL\","
  trigger="$trigger \"id\":\"chained-trigger\","
  trigger="$trigger \"enabled\":true,"
  trigger="$trigger \"autoDisable\":false,"
  trigger="$trigger \"autoEnable\":false,"
  trigger="$trigger \"autoResolve\":false,"
  trigger="$trigger \"autoResolveAlerts\":false,"
  trigger="$trigger \"severity\":\"HIGH\"}"

  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$trigger" $HAWKULAR_URL/triggers)
  
  if [ "$response" == "200" ]; 
  then
    echo "chained-trigger trigger created"
  else
    echo "chained-trigger trigger not created - aborting..."
    exit 1
  fi   

  ## Create condition
  
  local cond1="{\"triggerMode\":\"FIRING\","
  cond1="$cond1 \"type\":\"EVENT\","
  cond1="$cond1 \"dataId\":\"detect-undeployment-containerZ-with-errors\"}"

  local response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$cond1" $HAWKULAR_URL/triggers/chained-trigger/conditions)

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
create_first_trigger_and_conditions;
create_chained_trigger;