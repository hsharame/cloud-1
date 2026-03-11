FROM	debian:bookworm

RUN	apt-get update && apt-get install -y \
	nginx \
	curl \
	gettext-base \
	&& mkdir -p /var/run/nginx \
	&& chmod 755 /var/www/html \
	&& chown -R www-data:www-data /var/www/html \
	&& rm -rf /var/lib/apt/lists/*

COPY	conf/nginx.conf.template /etc/nginx/templates/nginx.conf.template

EXPOSE	80 443

CMD	["/bin/sh", "-c", "envsubst '$DOMAIN_NAME' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
