#!/bin/bash

# System Variables ===============================================
at="{{at}}"
lssn="{{lssn}}"

# Create query string
qs="at=$at&lssn=$lssn"
APIURL="https://giipapi.azurewebsites.net/server/delete?$qs"

# Send GET request
curl -X DELETE "$APIURL"