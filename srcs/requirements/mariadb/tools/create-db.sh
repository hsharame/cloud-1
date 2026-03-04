#!/bin/bash

#service mysql start

#arreter en cas d'erreur
set -e 

if [ ! -d "/var/lib/mysql/mysql" ]; then
	chown -R mysql:mysql /var/lib/mysql
	chmod 750 /var/lib/mysql
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql --basedir=/usr
fi

if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then

    cat << EOF > /tmp/create_db.sql
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE \`${SQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    mysqld --user=mysql --bootstrap < /tmp/create_db.sql
    rm -f /tmp/create_db.sql

fi

exec mysqld --user=mysql
