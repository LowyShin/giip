#!/bin/bash

# System Variables ===============================================
sk="{{sk}}"
csn="{{csn}}"
cgsn="{{cgsn}}"
RQ_PSSn="{{RQ_PSSn}}"

# Create query string
qs="at=$sk&cSn=$cSn&cgsn=$cgsn&RQ_PSSn=$RQ_PSSn"
APIURL="https://giipapi.azurewebsites.net/server/list?$qs"

# Send GET request
curl -X GET "$APIURL"