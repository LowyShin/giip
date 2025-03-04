#!/bin/bash

# giip Variables 
at="{{at}}"
cCode="{{cCode}}"
cName="{{cName}}"
cAddrZip="{{cAddrZip}}"
cAddr="{{cAddr}}"
cTel="{{cTel}}"
cFax="{{cFax}}"
cURL="{{cURL}}"
cNote="{{cNote}}"

# Create JSON body
body='{
    "at": "'$at'",
    "cCode": "'$cCode'",
    "cName": "'$cName'",
    "cAddrZip": "'$cAddrZip'",
    "cAddr": "'$cAddr'",
    "cTel": "'$cTel'",
    "cFax": "'$cFax'",
    "cURL": "'$cURL'",
    "cNote": "'$cNote'",
}'

APIURL="https://giipapi.azurewebsites.net/project/create"

# Send POST request
curl -s -X POST "$APIURL" \
    -H "Content-Type: application/json" \
    -d "$body"