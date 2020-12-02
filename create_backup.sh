#!/bin/bash

# ---------------- Variables ----------------
backup_dir="/opt/prestashop/backup"
mysql_env_file="/opt/prestashop/mysql.env"
mysql_container_name="prestashop_mysql_1"
mysql_db_name="prestashop"
mysql_configuration_table_name="configuration"
prestashop_webroot="/opt/prestashop/prestashop"
# -------------- End Variables --------------


# Clear backup directory
rm -r $backup_dir/*

# Read DB password from environment file
db_pw=$(grep -oP 'MYSQL_ROOT_PASSWORD=\K(.*)' $mysql_env_file)

# Get ID of MySQL container
mysql_id=$(docker ps --filter "name=$mysql_container_name" --format "{{.ID}}")

# Enable maintenance mode for prestashop
echo "Enabling maintenance mode."
docker exec -it $mysql_id /usr/bin/mysql -u root -p$db_pw -e "UPDATE \`$mysql_db_name\`.\`$mysql_configuration_table_name\` set \`value\`=0 WHERE \`name\`='PS_SHOP_ENABLE';"

# Create backup of webroot
echo "Creating backup of webroot."
cp -r "$prestashop_webroot" "$backup_dir/prestashop" 

# Create backup of DB
echo "Creating backup of database."
(docker exec $mysql_id /usr/bin/mysqldump -u root -p$db_pw --opt --databases $mysql_db_name) > $backup_dir/prestashop.sql

# Disable maintenance mode for prestashop
echo "Disabling maintenance mode."
docker exec $mysql_id /usr/bin/mysql -u root -p$db_pw -e "UPDATE \`$mysql_db_name\`.\`$mysql_configuration_table_name\` set \`value\`=1 WHERE \`name\`='PS_SHOP_ENABLE';"
