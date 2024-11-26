#!/bin/bash

# System Variables ===============================================
sk="{{sk}}"
cSn="{{cSn}}"
LSsn="{{LSsn}}"

# Create query string
qs="at=$sk&cSn=$cSn&LSsn=$LSsn"
APIURL="https://giipapi.azurewebsites.net/server/custom/list?$qs"

# Send GET request
curl -X GET "$APIURL"