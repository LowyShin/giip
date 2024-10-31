#!/bin/bash

# Send data to GIIP KVS API
send_to_giip() {
    local sk="$1"
    local lssn="$2"
    local factor="$3"
    local rstjson="$4"
    
    curl -X POST "https://giip.example.com/kvs" \
        --data-urlencode "sk=$sk" \
        --data-urlencode "type=lssn" \
        --data-urlencode "key=$lssn" \
        --data-urlencode "factor=$factor" \
        --data-urlencode "value=$rstjson"
}

# Parameter check
if [ "$#" -ne 6 ]; then
    echo "Usage: $0 <DB_HOST> <NEW_USER> <NEW_USER_PASSWORD> <ROLE_NAME> <DB_ADMIN> <DB_ADMINPWD>"
    exit 1
fi

TODAY=$(date +'%Y-%m-%d')

# Get arguments
DB_HOST=$1
DB_PORT=3306
PRE_HOST="${DB_HOST%%.*}"

DB_USER=$5
DB_PASSWORD=$6

# New username and role name
NEW_USER=$2
NEW_USER_PASSWORD=$3
ROLE_NAME=$4
CSV_FILE="${PRE_HOST}_${2}_${TODAY}.csv"  # Output CSV file name

# Create user and grant role
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" --ssl-mode=DISABLED  <<EOF
CREATE USER '$NEW_USER'@'%' IDENTIFIED BY '$NEW_USER_PASSWORD';
GRANT $ROLE_NAME TO '$NEW_USER'@'%';
FLUSH PRIVILEGES;
EOF

# Check the execution result of the script
if [ $? -eq 0 ]; then
    echo "User '$NEW_USER' has been created and role '$ROLE_NAME' has been granted."
    status="success"
else
    echo "Failed to create user or grant role."
    status="error"
    result="{\"status\":\"$status\",\"message\":\"Failed to create user or grant role.\"}"
    send_to_giip "{{sk}}" "{{lssn}}" "user_creation" "$result"
    exit 1
fi

# Extract the created user and save to CSV
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT User, Host, @@aurora_server_id AS Server_ID FROM mysql.user WHERE User='$NEW_USER'" --batch --skip-column-names --ssl-mode=DISABLED | sed 's/\t/,/g' > "$CSV_FILE"

# Get grant information and append to CSV
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" -e "SHOW GRANTS FOR '$NEW_USER'@'%';" --batch --skip-column-names --ssl-mode=DISABLED | sed 's/\t/,/g' >> "$CSV_FILE"

# Check CSV file
if [ $? -eq 0 ]; then
    echo "User information has been saved to '$CSV_FILE'."
    status="success"
else
    echo "Failed to extract user information."
    status="error"
    result="{\"status\":\"$status\",\"message\":\"Failed to extract user information.\"}"
    send_to_giip "{{sk}}" "{{lssn}}" "user_info_extraction" "$result"
    exit 1
fi

# Read CSV and convert to JSON
json_data=$(awk -F, 'BEGIN {ORS=""; print "{\"user_info\":["} {print "{\"User\":\""$1"\",\"Host\":\""$2"\",\"Server_ID\":\""$3"\"}"} END {print "]}"}' "$CSV_FILE")

# Prepare final JSON
result="{\"status\":\"$status\",\"user\":\"$NEW_USER\",\"role\":\"$ROLE_NAME\",\"data\":$json_data}"

# Send the result to GIIP API
send_to_giip "{{sk}}" "{{lssn}}" "user_creation" "$result"
