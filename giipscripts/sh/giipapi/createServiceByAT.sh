#!/bin/bash

# giip Variables 
at="{{at}}"
csn="{{csn}}"
CgCode="{{CgCode}}"
cgName="{{cgName}}"
CGDesc="{{CGDesc}}"

# Create JSON
JSON=$(cat << EOF
{
  "at": "$at",
  "csn": "$csn",
  "CgCode": $CgCode,
  "cgName": $cgName,
  "CGDesc": $CGDesc
}
EOF
)

# URL encode the JSON for query string
encoded_json=$(echo "$JSON" | jq -R -s -c '.' | sed 's/"/\\"/g')

# Create query string
body="value=$encoded_json"
APIURL="https://giipapi.azurewebsites.net/service/create"

# Send POST request
curl -s -X POST "$APIURL" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-raw "$body" \