#!/bin/bash

set -e

cd /var/www/wordpress

until mariadb -h"${DB_HOST}" -u"${SQL_USER}" -p"${SQL_PASSWORD}" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
done

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
