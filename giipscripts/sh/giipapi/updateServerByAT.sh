#!/bin/bash

# giip Variables 
sk="{{sk}}"
LSLSSN="{{LSLSSN}}"
LSHostName="{{LSHostName}}"
mf="{{mf}}"
LSSpecCPU="{{LSSpecCPU}}"
LSSpecCPUS="{{LSSpecCPUS}}"
LSSpecRAMGB="{{LSSpecRAMGB}}"
LSOSVer="{{LSOSVer}}"

# Create JSON
JSON=$(cat << EOF
{
  "sk": "$sk",
  "LSLSSN": "$LSLSSN",
  "LSHostName": $LSHostName,
  "mf": $mf,
  "LSSpecCPU": $LSSpecCPU,
  "LSSpecCPUS": $LSSpecCPUS,
  "LSSpecRAMGB": $LSSpecRAMGB,
  "LSOSVer": $LSOSVer
}
EOF
)

# URL encode the JSON for query string
encoded_json=$(echo "$JSON" | jq -R -s -c '.' | sed 's/"/\\"/g')

# Create query string
body="value=$encoded_json"
APIURL="https://giipapi.azurewebsites.net/server/update"

# Send POST request
curl -s -X PUT "$APIURL" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    --data-raw "$body" \