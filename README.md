# hawkular-alerts HelloWorld

These examples show how to start using hawkular-alerts REST API from a bash script.

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

## create-definitions.sh

Create a hello world trigger to check if data-x < 5 and data-y > 5.

Add an email action to notify to a defined admins group.

Add a Dampening rule to fire an alert after 2 consecutive evaluations.

## send-data.sh

Send data-x and data-y data using REST endpoint

```
GET /hawkular/alerts/data
```
