#!/bin/bash

# giip Variables 
at="{{at}}"
csn="{{csn}}"
cgSn="{{cgSn}}"
lsUsage="{{lsUsage}}"
lsHostName="{{lsHostName}}"

# Create JSON
JSON=$(cat << EOF
{
  "at": "$at",
  "csn": "$csn",
  "cgSn": $cgSn,
  "lsUsage": $lsUsage,
  "lsHostName": $lsHostName
}
EOF
)

# URL encode the JSON for query string
encoded_json=$(echo "$JSON" | jq -R -s -c '.' | sed 's/"/\\"/g')

# Create query string
body="value=$encoded_json"
APIURL="https://giipapi.azurewebsites.net/server/create"

# Send POST request
curl -s -X POST "$APIURL" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-raw "$body" \