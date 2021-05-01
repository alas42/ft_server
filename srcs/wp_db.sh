#! /bin/bash

DB_USER="root"
DB_PASS=""
DB_HOST="localhost"
DB_NAME="wordpress"

service mysql start

echo "Creating Database $DB_NAME"
mysql -u $DB_USER -e "CREATE DATABASE $DB_NAME"
mysql -u $DB_USER -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';"
mysql -u $DB_USER -e "FLUSH PRIVILEGES;"
mysql -u $DB_USER -e "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user='root';"

