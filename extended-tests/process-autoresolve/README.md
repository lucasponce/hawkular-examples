# hawkular-alerts Process AUTORESOLVE

These examples introduces AUTORESOLVE feature in hawkular-alerts.

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

## create-definition-check-process.sh

This script defines a Trigger to detect if a firefox process is running.

When the process is DOWN a new alert will be fired.

When the process is back to UP the previous generated alert will be resolved automatically.

First, we create the trigger with autoResolve and autoResolveAlerts flag to true:

```javascript
   {
        "autoResolve": true,
        "autoResolveAlerts": true
    }
```

Next, we will create the conditions:

```javascript
[
    {
        "tenantId":"my-organization",
        "triggerId":"check-firefox-process",
        "triggerMode":"FIRING",
        "type":"AVAILABILITY",
        "conditionSetSize":1,
        "conditionSetIndex":1,
        "conditionId":"check-firefox-process-FIRING-1-1",
        "dataId":"firefox-process",
        "operator":"NOT_UP"
    },
    {
        "tenantId":"my-organization",
        "triggerId":"check-firefox-process",
        "triggerMode":"AUTORESOLVE",
        "type":"AVAILABILITY",
        "conditionSetSize":1,
        "conditionSetIndex":1,
        "conditionId":"check-firefox-process-AUTORESOLVE-1-1",
        "dataId":"firefox-process",
        "operator":"UP"
    }
]
```

The first condition is defined with triggerMode FIRING. This is the standar behaviour of a trigger, this conditions 
is in charge to detect when the firefox process is down.

The second condition is defined with triggerMode AUTORESOLVE. This means that when a process is detected down, the 
trigger will change its mode to AUTORESOLVE, not detecting when the process is DOWN but when is UP again.

This behaviour can implement that once a process is down, repeated alerts for that condition won't be sent, but the 
trigger is detecting when the issue is gone.

## send-data-check-process.sh

A simple batch that check is firefox process is up using ps command and send availability data through REST endpoint.

