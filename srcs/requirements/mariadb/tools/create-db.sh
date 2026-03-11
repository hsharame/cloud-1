#!/bin/bash
set -e

mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld
chmod 750 /var/lib/mysql
chmod 755 /run/mysqld

INIT_DB=0

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --basedir=/usr
    INIT_DB=1
fi

mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
pid="$!"

until mariadb-admin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
    sleep 1
done

if [ "$INIT_DB" -eq 1 ]; then
    mariadb --socket=/run/mysqld/mysqld.sock <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`
CHARACTER SET utf8
COLLATE utf8_general_ci;

CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
ALTER USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF
else
    mariadb --socket=/run/mysqld/mysqld.sock -uroot -p"${SQL_ROOT_PASSWORD}" <<EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`
CHARACTER SET utf8
COLLATE utf8_general_ci;

CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
ALTER USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF
fi

mariadb-admin --socket=/run/mysqld/mysqld.sock -uroot -p"${SQL_ROOT_PASSWORD}" shutdown
wait "$pid" 2>/dev/null || true

exec mysqld --user=mysql --console
