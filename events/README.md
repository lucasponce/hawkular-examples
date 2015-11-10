# hawkular-examples events

These examples shows how to use the events API in hawkular-alerts.

These tutorial scripts are tested against a standalone deployment of hawkular-alerts.

Main difference between REST API from hawkular or a hawkular-alerts standalone distribution is about the headers:

REST endpoint needs header authorization on hawkular deployments:

```
Authorization: Basic amRvZTpwYXNzd29yZA==
```

Hawkular manages the authorization and links with the associated tenant.

In standalone deployments it is needed to specify just the tenant:

```
Hawkular-Tenant: my-organization
```

## send-events-tutorial-01.sh

Minimalist example to send and event.

Event structure is used as:

```javascript
    {
        "id": "...",        // <A unique identifier for this event, typically an UUID>,
        "ctime": 123,       // <Creation time in milliseconds>,
        "category": "...",  // <Category of the event, used for filtering>,
        "text": "..."       // <Main content of the event>
     }
```

Events creation are sent to the following REST endpoint:

```
POST /hawkular/alerts/events
```

## send-events-tutorial-02.sh

Adding tags into events offers a structured way to add information used for filtering.

Tags is a map of key/value that can be used to add additional information into the event structure.
All info placed into tags map can be used for filtering.

In the deployments events we are adding:

```javascript
    {
        "tags": {
            "operation": "...",     // Type of operation,
            "app": "...",           // Name of the application which is event is referring,
            "container": "..."       // Name of the container where the app is deployed,
        }
    }
```

And in the log events:

```javascript
    {
        "tags": {
            "app": "...",           // Name of the application which is event is referring,
        }
    }
```

Events can be queried using the following REST endpoint:

```
GET /hawkular/alerts/events                             // For all events
```

```
GET /hawkular/alerts/events?categories=DEPLOYMENT,LOG   // Filtering by specific categories
```

```
GET /hawkular/alerts/events?tags=app|appA,app|appB      // Filtering by specific tags
```

## create-events-triggers-tutorial-03.sh

Trigger creation to detect undeployment events on containerZ.

Previous triggers with same id are deleted to generate a new one:

```javascript
    {
        "id":"detect-undeployment-containerZ",
        "name":"Undeployments detection",
        "action":["email-to-admin-group"],
        "severity":"HIGH"
    }
```

Once trigger is created we can add a condition to fire an alert on undeployment events for containerZ:

```javascript
    {
        "triggerMode":"FIRING",
        "type":"EVENT",
        "dataId":"events-source",
        "expression":"tags.operation == 'undeployment',tags.container == 'containerZ'"
    }
```

The condition must have a dataId to define an events source. This means that only events with dataId == 
"events-source" will be evaluated against this rule.

## send-events-tutorial-03.sh

This example sends multiple random events in a loop.

Note that deployment events are marked with dataId equals to "events-source'. 

```javascript
    {
        "id": "...",        // <A unique identifier for this event, typically an UUID>,
        "ctime": 123,       // <Creation time in milliseconds>,
        "category": "...",  // <Category of the event, used for filtering>,
        "text": "...",      // <Main content of the event>
        "dataId": "...",    // <Define a source of events>
                            // This dataId is used in trigger conditions to indicate which
                            // source of events should be used for evaluation
     }
```

This means that only deployment events are processed for alerting. 

A dataId is active if there is a reference of it on a trigger condition. Only events with dataId actives are 
evaluated by the engine.

## create-events-triggers-tutorial-04.sh

Trigger creation to detect undeployments events on containerZ and errors on log.

This trigger won't have any action defined, it will only create an alert.

```javascript
    {
        "id":"detect-undeployment-containerZ-with-errors",
        "name":"Undeployments detection with Errors",
        "severity":"HIGH"
    }
```

A first Trigger is created now with two conditions, each condition has a different dataId to make sure that only events 
with same dataId are evaluated against its specific condition.

```javascript
  [
    {
        "triggerMode":"FIRING",
        "type":"EVENT",
        "dataId":"events-deployments-source",
        "expression":"tags.operation == 'undeployment',tags.container == 'containerZ'"
     },
    {
        "triggerMode":"FIRING",
        "type":"EVENT",
        "dataId":"events-logs-source",
        "expression":"text starts 'ERROR'"
    }
  ]
```

A second trigger will be created to detect events generated for the first trigger and send actions.

```javascript
    {
        "id":"chained-trigger",
        "name":"Chained trigger",
        "description":"Show how to define a trigger using Events generated from other trigger",
        "action":["email-to-admin-group"],
        "severity":"HIGH"
    }
```

This chained trigger uses an EVENT condition pointing as the previous trigger as dataId. If no expression is added 
the condition will be evaluated when a new Event is created. 

```javascript
    {
        "triggerMode":"FIRING",
        "type":"EVENT",
        "dataId":"detect-undeployment-containerZ-with-errors"
    }
```

Alerts are a specific type of events, so EVENT condition can be used to detect new alerts generated by the engine.

## send-events-tutorial-04.sh

This example sends multiple random events in a loop.

Deployment events are assigned with "events-deployments-source" dataId to make sure that only are evaluated with 
its specific conditions.

Log events are assigned with "events-log-source" dataId to define a different events source and make sure that these 
events are only evaluated with its specific conditions.

## create-events-triggers-tutorial-05.sh

Trigger creation to detect undeployments events on containerZ and errors on log similar as 
create-events-triggers-tutorial-04.sh example, but now it will generate a new simple Event.
 
```javascript
    {
        "id":"detect-undeployment-containerZ-with-errors",
        "name":"Undeployments detection with Errors",
        "severity":"HIGH",
        "eventType":"EVENT"
    }
```
  
Alerts will be generated just by the chained trigger.

## send-events-tutorial-05.sh

This example sends multiple random events in a loop similar as send-events-tutorial-04.sh.

## clean-all.sh

Important: Delete all alerts and events