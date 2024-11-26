#!/bin/bash

# System Variables ===============================================
at="{{at}}"
cSn="{{cSn}}"

# Create query string
qs="at=$at&cSn=$cSn"
APIURL="https://giipapi.azurewebsites.net/script/detail?$qs"

# Send GET request
curl -X GET "$APIURL"