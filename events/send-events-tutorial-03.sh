#!/bin/bash

HAWKULAR_URL="http://localhost:8080/hawkular/alerts"
DEMO_TENANT="my-organization"

HEADER_JSON="Content-Type: application/json"
HEADER_TENANT="Hawkular-Tenant: $DEMO_TENANT"

function post_event() {

    local event=$1
    
    echo "Send $event"
    
    local response=$(curl -X POST --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" -H "$HEADER_TENANT" --data "$event" $HAWKULAR_URL/events)
    if [ "$response" != "200" ]; 
    then
      echo "$response data not sent - aborting..."      
      exit 1
    fi   

}

function send_deployment_event() {

    declare -a operations=("deployment" "undeployment")
    declare -a containers=("containerX" "containerY" "containerZ")
    declare -a apps=("appA" "appB" "appC")

    local uuid=$(uuidgen)
    local timestamp=$(date +%s)
    
    local op_id=$(shuf -i0-1 -n1)
    local container_id=$(shuf -i0-2 -n1)
    local app_id=$(shuf -i0-2 -n1)
        
    local event="{\"id\":\"$uuid\","
    event="$event\"ctime\":$timestamp,"
    event="$event\"category\":\"DEPLOYMENT\","
    event="$event\"text\":\"${operations[op_id]} of ${apps[app_id]} on ${containers[container_id]}\","
    event="$event\"dataId\":\"events-source\","
    event="$event\"tags\":{"
    event="$event\"operation\":\"${operations[op_id]}\","
    event="$event\"app\":\"${apps[app_id]}\","
    event="$event\"container\":\"${containers[container_id]}\"}}"
    
    post_event "$event"
    
}

function send_log_event() {
    
    declare -a messages    
    messages[0]="ERROR [org.hawkular.alerts.actions.api] (ServerService Thread Pool -- 62) HAWKALERT240006: Plugin [aerogear] cannot be started. Error: [Configure org.hawkular.alerts.actions.aerogear.root.server.url, org.hawkular.alerts.actions.aerogear.application.id and org.hawkular.alerts.actions.aerogear.master.secret]"
    messages[1]="WARN [org.hawkular.alerts.engine.impl.CassDefinitionsServiceImpl] (ServerService Thread Pool -- 62) [15] Retrying connecting to Cassandra cluster in [3000]ms..."
    messages[2]="INFO [org.jboss.as] (Controller Boot Thread) WFLYSRV0025: WildFly Full 9.0.1.Final (WildFly Core 1.0.1.Final) started in 18402ms - Started 1064 of 1278 services (292 services are lazy, passive or on-demand)"
    declare -a apps=("appA" "appB" "appC")

    local uuid=$(uuidgen)
    local timestamp=$(date +%s)
    
    local message_id=$(shuf -i0-2 -n1)
    local app_id=$(shuf -i0-2 -n1)
    
    local event="{\"id\":\"$uuid\","
    event="$event\"ctime\":$timestamp,"
    event="$event\"category\":\"LOG\","
    event="$event\"text\":\"${messages[message_id]}\","
    event="$event\"tags\":{"
    event="$event\"app\":\"${apps[app_id]}\"}}"
    
    post_event "$event"            
    
}

function send_events() {

    while true
    do    
        send_deployment_event;
        send_log_event;
    
        sleep 0.5
    done
    
}

## Main

send_events;






