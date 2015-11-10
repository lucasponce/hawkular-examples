#!/bin/bash

HAWKULAR_URL="http://localhost:8080/hawkular/alerts"
DEMO_TENANT="my-organization"

HEADER_JSON="Content-Type: application/json"
HEADER_TENANT="Hawkular-Tenant: $DEMO_TENANT"

function create_actions() {

  ## Clean old aerogear action

  response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/aerogear/agpush-to-admin-group)

  if [ "$response" == "404" ];
  then
    echo "agpush-to-admin-group action is not present"
  else
    echo "deleting old agpush-to-admin-group action"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/aerogear/agpush-to-admin-group)
  fi
    
  ## Create new aerogear action  
    
  action="{\"actionPlugin\":\"aerogear\","
  action="$action \"actionId\":\"agpush-to-admin-group\","
  action="$action \"alias\":\"Ottis B Driftwood\","
  action="$action \"description\":\"Aerogear action description example\"}"
  
  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$action" $HAWKULAR_URL/actions)

  if [ "$response" == "200" ]; 
  then
    echo "aerogear action created"
  else
    echo "aerogear action not created - aborting..."
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
  
  ## Clean old file action

  response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/file/file-to-admin-group)

  if [ "$response" == "404" ];
  then
    echo "file-to-admin-group action is not present"
  else
    echo "deleting old file-to-admin-group action"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/file/file-to-admin-group)
  fi  
  
  ## Create new file action 
  
  action="{\"actionPlugin\":\"file\","
  action="$action \"actionId\":\"file-to-admin-group\"}"
  
  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$action" $HAWKULAR_URL/actions)

  if [ "$response" == "200" ]; 
  then
    echo "file action created"
  else
    echo "file action not created - aborting..."
    exit 1
  fi     

  ## Clean old pagerduty action

  response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/pagerduty/pagerduty-to-admin-group)

  if [ "$response" == "404" ];
  then
    echo "pagerduty-to-admin-group action is not present"
  else
    echo "deleting old pagerduty-to-admin-group action"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/pagerduty/pagerduty-to-admin-group)
  fi  

  ## Create new pagerduty action 
  
  action="{\"actionPlugin\":\"pagerduty\","
  action="$action \"actionId\":\"pagerduty-to-admin-group\"}"
  
  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$action" $HAWKULAR_URL/actions)

  if [ "$response" == "200" ]; 
  then
    echo "pagerduty action created"
  else
    echo "pagerduty action not created - aborting..."
    exit 1
  fi     
  
  ## Clean old sms action

  response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/sms/sms-to-admin-group)

  if [ "$response" == "404" ];
  then
    echo "sms-to-admin-group action is not present"
  else
    echo "deleting old sms-to-admin-group action"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/actions/sms/sms-to-admin-group)
  fi  

  ## Create new sms action  
    
  action="{\"actionPlugin\":\"sms\","
  action="$action \"actionId\":\"sms-to-admin-group\","
  action="$action \"phone\":\"+14108675309\","
  action="$action \"description\":\"SMS plugin example\"}"
  
  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$action" $HAWKULAR_URL/actions)

  if [ "$response" == "200" ]; 
  then
    echo "aerogear action created"
  else
    echo "aerogear action not created - aborting..."
    exit 1
  fi     
  
  
}

function create_trigger() {

  ## Clean old trigger definition
  
  local response=$(curl --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/trigger-for-poc)
  
  if [ "$response" == "404" ];
  then
    echo "trigger-for-poc trigger is not present"
  else
    echo "deleting old trigger-for-poc trigger"
    response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" $HAWKULAR_URL/triggers/trigger-for-poc)
  fi  
  
  ## Create new trigger

  local trigger="{\"name\":\"trigger-for-poc\","
  trigger="$trigger \"description\":\"Trigger for PoC\","
  trigger="$trigger \"actions\":{"
  trigger="$trigger \"aerogear\":[\"agpush-to-admin-group\"],"
  trigger="$trigger \"email\":[\"email-to-admin-group\"],"  
  trigger="$trigger \"file\":[\"file-to-admin-group\"],"
  trigger="$trigger \"pagerduty\":[\"pagerduty-to-admin-group\"],"
  trigger="$trigger \"sms\":[\"sms-to-admin-group\"]"
  trigger="$trigger },"
  # trigger="$trigger \"actions\":{\"pagerduty\":[\"pagerduty-to-admin-group\"]},"
  # trigger="$trigger \"actions\":{\"sms\":[\"sms-to-admin-group\"]},"
  trigger="$trigger \"firingMatch\":\"ALL\","
  trigger="$trigger \"autoResolveMatch\":\"ALL\","
  trigger="$trigger \"id\":\"trigger-for-poc\","
  trigger="$trigger \"enabled\":true,"
  trigger="$trigger \"autoDisable\":false,"
  trigger="$trigger \"autoEnable\":false,"
  trigger="$trigger \"autoResolve\":false,"
  trigger="$trigger \"autoResolveAlerts\":false,"
  trigger="$trigger \"severity\":\"HIGH\"}"

  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$trigger" $HAWKULAR_URL/triggers)
  
  if [ "$response" == "200" ]; 
  then
    echo "trigger-for-poc trigger created"
  else
    echo "trigger-for-poc trigger not created - aborting..."
    exit 1
  fi   
    
}

function create_conditions() {

  ## Create first condition
  
  local cond1="{\"triggerMode\":\"FIRING\","
  cond1="$cond1 \"type\":\"THRESHOLD\","
  cond1="$cond1 \"dataId\":\"data-x\","
  cond1="$cond1 \"operator\":\"LT\","
  cond1="$cond1 \"threshold\":5}";

  local response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$cond1" $HAWKULAR_URL/triggers/trigger-for-poc/conditions)

  if [ "$response" == "200" ]; 
  then
    echo "condition1 created"
  else
    echo "condition1 not created - aborting..."
    exit 1
  fi   
  
  ## Create a second conditions
  
  local cond2="{\"triggerMode\":\"FIRING\","
  cond2="$cond2 \"type\":\"THRESHOLD\","
  cond2="$cond2 \"dataId\":\"data-y\","
  cond2="$cond2 \"operator\":\"GT\","
  cond2="$cond2 \"threshold\":5}";
    
  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$cond2" $HAWKULAR_URL/triggers/trigger-for-poc/conditions)

  if [ "$response" == "200" ]; 
  then
    echo "condition2 created"
  else
    echo "condition2 not created - aborting..."
    exit 1
  fi   
  
  ## Create a dampening condition
  
  local damp="{\"type\":\"STRICT\","
  damp="$damp \"evalTrueSetting\":2,"
  damp="$damp \"evalTotalSetting\":2}"
  
  response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$damp" $HAWKULAR_URL/triggers/trigger-for-poc/dampenings)

  if [ "$response" == "200" ]; 
  then
    echo "dampening created"
  else
    echo "dampening not created - aborting..."
    exit 1
  fi      
}

## Main

create_actions;
create_trigger;
create_conditions;