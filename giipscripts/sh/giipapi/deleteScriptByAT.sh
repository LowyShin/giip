#!/bin/bash

# System Variables ===============================================
at="{{at}}"
mssn="{{mssn}}"

# Create query string
qs="at=$at&mssn=$mssn"
APIURL="https://giipapi.azurewebsites.net/script/delete?$qs"

# Send GET request
curl -X DELETE "$APIURL"