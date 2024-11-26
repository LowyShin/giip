#!/bin/bash

# System Variables ===============================================
at="{{at}}"
cSn="{{cSn}}"

# Create query string
qs="at=$at&cSn=$cSn&cgsn=$cgsn&RQ_PSSn=$RQ_PSSn"
APIURL="https://giipapi.azurewebsites.net/service/list?$qs"

# Send GET request
curl -X GET "$APIURL"