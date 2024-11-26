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

# Create JSON
JSON=$(cat << EOF
{
  "at": "$at",
  "cCode": "$cCode",
  "CName": $CName,
  "cAddrZip": $cAddrZip,
  "cAddr": $cAddr,
  "cTel": $cTel,
  "cFax": $cFax,
  "cURL": $cURL,
  "cNote": $cNote
}
EOF
)

# URL encode the JSON for query string
encoded_json=$(echo "$JSON" | jq -R -s -c '.' | sed 's/"/\\"/g')

# Create query string
body="value=$encoded_json"
APIURL="https://giipapi.azurewebsites.net/project/create"

# Send POST request
curl -s -X POST "$APIURL" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-raw "$body" \