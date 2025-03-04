#!/bin/bash

# System Variables ===============================================
at="{{at}}"
LSLSSN="{{LSLSSN}}"

# Create query string
qs="at=$at&LSLSSN=$LSLSSN"
APIURL="https://giipapi.azurewebsites.net/server/detail?$qs"

# Send GET request
curl -X GET "$APIURL"