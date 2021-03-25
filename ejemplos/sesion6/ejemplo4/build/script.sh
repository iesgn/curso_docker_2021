#!/bin/bash
sed -i 's/$this->user="root";/$this->user="'${MARIADB_USER}'";/g' /var/www/html/core/controller/Database.php
sed -i 's/$this->pass="";/$this->pass="'${MARIADB_PASS}'";/g' /var/www/html/core/controller/Database.php
sed -i 's/$this->host="localhost";/$this->host="'${MARIADB_HOST}'";/g' /var/www/html/core/controller/Database.php
sleep 5
mysql -u ${MARIADB_USER} -p${MARIADB_PASS} -h ${MARIADB_HOST} bookmedik < /opt/schema.sql

apache2ctl -D FOREGROUND
