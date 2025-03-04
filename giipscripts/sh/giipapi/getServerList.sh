#!/bin/bash

# System Variables ===============================================
at="{{at}}"
csn="{{csn}}"
cgsn="{{cgsn}}"
RQ_PSSn="{{RQ_PSSn}}"

# Create query string
qs="at=$at&cSn=$cSn&cgsn=$cgsn&RQ_PSSn=$RQ_PSSn"
APIURL="https://giipapi.azurewebsites.net/server/list?$qs"

# Send GET request
curl -X GET "$APIURL"