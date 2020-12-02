# prestashop-docker-backup
Backup a dockerized PrestaShop installation.

This script can be used to create a backup of a dockerized PrestaShop installation. The script enables maintenance mode, creates a backup of the database and webroot and finally disables maintenance mode.

## Usage
Change the following variables in the beginning of [create_backup.sh](create_backup.sh)
* **backup_dir:** The directory to store the backup
* **mysql_env_file:** The path to the environment-file for MySQl containing the root-Passwort for the dockerized MySQL-server
* **mysql_container_name:** Name of the MySQL docker container
* **mysql_db_name:** Name of the PrestaShop MySQL database
* **mysql_configuration_table_name:** Name of the PrestaShop MySQL configuration database
* **prestashop_webroot:** Path to the webroot of PrestaShop to be backed up
