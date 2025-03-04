#!/bin/bash

# System Variables ===============================================
at="{{at}}"
cSn="{{cSn}}"
LSsn="{{LSsn}}"

# Create query string
qs="at=$at&cSn=$cSn&LSsn=$LSsn"
APIURL="https://giipapi.azurewebsites.net/server/custom/list?$qs"

# Send GET request
curl -X GET "$APIURL"