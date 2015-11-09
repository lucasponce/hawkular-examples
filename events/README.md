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