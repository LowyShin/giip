#!/bin/bash

# System Variables ===============================================
sk="{{sk}}"
cSn="{{cSn}}"

# Create query string
qs="sk=$sk&cSn=$cSn"
APIURL="https://giipapi.azurewebsites.net/project/list?$qs"

# Send GET request
curl -X GET "$APIURL"