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

Adding tags into events offer a structured way to add information used for filtering.

Tags is a map of key/value that can be used to add additional information into the event structure.
All info placed into tags map can be used for filtering.

In the deployments events we are adding:

```javascript
    {
        ...
        "tags": {
            "operation": "...",     // Type of operation,
            "app": "...",           // Name of the application which is event is referring,
            "container:" ..."       // Name of the container where the app is deployed,
        }
    }
```

And in the log events:

```javascript
    {
        ...
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





