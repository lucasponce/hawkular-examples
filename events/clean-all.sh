#!/bin/bash

HAWKULAR_URL="http://localhost:8080/hawkular/alerts"
DEMO_TENANT="my-organization"

HEADER_JSON="Content-Type: application/json"
HEADER_TENANT="Hawkular-Tenant: $DEMO_TENANT"

function delete_events_and_alerts() {

    local response=$(curl -X PUT --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" \
    -H "$HEADER_TENANT" "$HAWKULAR_URL/events/delete")

    printf "Deleting events... $response\n"

    response=$(curl -X PUT --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" \
    -H "$HEADER_TENANT" "$HAWKULAR_URL/delete")

    printf "Deleting alerts... $response\n"

}

function delete_trigger() {

    local triggerId=$1

    local response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_JSON" \
    -H "$HEADER_TENANT" "$HAWKULAR_URL/triggers/$triggerId")

    printf "Deleting triggerId: $triggerId... $response\n"

}

function delete_all_triggers() {

    delete_trigger "detect-undeployment-containerZ"
    delete_trigger "detect-undeployment-containerZ-with-errors"
    delete_trigger "chained-trigger"

}

function delete_action() {

    local response=$(curl -X DELETE --write-out %{http_code} --silent --output /dev/null -H "$HEADER_TENANT" \
    "$HAWKULAR_URL/actions/email/email-to-admin-group")

    printf "Deleting action... $response\n"
}


## Main

delete_events_and_alerts;
delete_all_triggers;
delete_action;