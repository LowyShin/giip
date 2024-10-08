#!/bin/bash

# Parameter check
if [ "$#" -ne 6 ]; then
    echo "Usage: $0 <DB_HOST> <NEW_USER> <NEW_USER_PASSWORD> <ROLE_NAME> <DB_ADMIN> <DB_ADMINPWD>"
    exit 1
fi

TODAY=$(date +'%Y-%m-%d')

# Get arguments
DB_HOST=$1
DB_PORT=3306
# DB_NAME=$3
PRE_HOST="${DB_HOST%%.*}"

DB_USER=$5
DB_PASSWORD=$6

# New username and role name
NEW_USER=$2  # Change this to specify the new username
NEW_USER_PASSWORD=$3  # Change this to specify the new user's password
ROLE_NAME=$4  # Change this to specify the new role name
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
else
    echo "Failed to create user or grant role."
    exit 1
fi

# Extract the created user and save to CSV
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT User, Host, @@aurora_server_id AS Server_ID FROM mysql.user WHERE User='$NEW_USER'" --batch --skip-column-names --ssl-mode=DISABLED | sed 's/\t/,/g' > "$CSV_FILE"

# Get grant information and append to CSV
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" -e "SHOW GRANTS FOR '$NEW_USER'@'%';" --batch --skip-column-names --ssl-mode=DISABLED | sed 's/\t/,/g' >> "$CSV_FILE"

# Check CSV file
if [ $? -eq 0 ]; then
    echo "User information has been saved to '$CSV_FILE'."
else
    echo "Failed to extract user information."
    exit 1
fi
