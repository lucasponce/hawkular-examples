# hawkular-alerts Extended-Tests

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

## minimal-trigger

This example shows how to create a minimal trigger. Interesting to use to add new properties in a iterative way and 
check which values are set up by default.

## multiple-actions

This script defines a trigger with multiple actions created in multiple plugins.

## process-autoresolve

HelloWorld example adapted to check and alert availability of a simple process using bash scripts.
It shows how to use advanced featured as AUTORESOLVE to detect when process is up or down and fire an alert on each 
state.
