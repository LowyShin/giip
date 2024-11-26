#!/bin/bash

# giip Variables 
at="{{at}}"
msName="{{msName}}"
msDetail="{{msDetail}}"
msBody="{{msBody}}"
msPer="{{msPer}}"
msPrice="{{msPrice}}"
msType="{{msType}}"

# Create JSON
JSON=$(cat << EOF
{
  "at": "$at",
  "msName": "$msName",
  "msDetail": $msDetail,
  "msBody": $msBody,
  "msPer": $msPer,
  "msPrice": $msPrice,
  "msType": $msType
}
EOF
)

# URL encode the JSON for query string
encoded_json=$(echo "$JSON" | jq -R -s -c '.' | sed 's/"/\\"/g')

# Create query string
body="value=$encoded_json"
APIURL="https://giipapi.azurewebsites.net/script/update"

# Send POST request
curl -s -X PUT "$APIURL" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-raw "$body" \