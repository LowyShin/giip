#!/bin/bash

# System Variables ===============================================
at="{{at}}"
cgSn="{{cgSn}}"

# Create query string
qs="at=$at&cgSn=$cgSn"
APIURL="https://giipapi.azurewebsites.net/service/delete?$qs"

# Send GET request
curl -X DELETE "$APIURL"