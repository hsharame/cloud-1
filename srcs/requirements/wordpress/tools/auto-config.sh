#!/bin/bash

set -e

sed -i "s|listen = /run/php/php7.4-fpm.sock|listen = 9000|" /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's/;daemonize = yes/daemonize = no/' /etc/php/7.4/fpm/php-fpm.conf

cd /var/www/wordpress

if [ ! -f wp-config.php ] ; then
	wp config create \
		--dbname=${SQL_DATABASE} \
		--dbuser=${SQL_USER} \
		--dbpass=${SQL_PASSWORD} \
		--dbhost=${DB_HOST} \
		--allow-root
fi

if ! wp core is-installed --allow-root; then
	wp core install --allow-root \
		--url=${DOMAIN_NAME} \
		--title="Inception" \
		--admin_user=${WP_ADMIN_USER} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--skip-email \
		--path='/var/www/wordpress'

	wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
		--user_pass="${WP_USER_PASSWORD}" \
		--role=editor \
		--allow-root \
		--path='/var/www/wordpress'
fi

php-fpm7.4 -F -R --nodaemonize
