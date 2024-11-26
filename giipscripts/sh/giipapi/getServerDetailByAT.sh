#!/bin/bash

# System Variables ===============================================
sk="{{sk}}"
LSLSSN="{{LSLSSN}}"

# Create query string
qs="sk=$sk&LSLSSN=$LSLSSN"
APIURL="https://giipapi.azurewebsites.net/server/detail?$qs"

# Send GET request
curl -X GET "$APIURL"