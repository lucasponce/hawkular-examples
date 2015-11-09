# hawkular-examples events

These examples shows how to use the events API in hawkular-alerts.

## send-events-tutorial-01.sh

Minimalist example to send and event.

Event structure is used as:

```json
    {
        "id": <A unique identifier for this event, typically an UUID>,
        "ctime": <Creation time in milliseconds>,
        "category": <Category of the event, used for filtering>,
        "text": <Main content of the event>
     }
```
