FROM	debian:bookworm

RUN	apt-get update && apt-get install -y \
	nginx \
	curl \
	openssl \
	gettext-base \
	&& mkdir -p /etc/nginx/ssl \
	&& mkdir -p /var/run/nginx \
	&& chmod 755 /var/www/html \
	&& chown -R www-data:www-data /var/www/html \
	&& openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt \
	-keyout /etc/nginx/ssl/inception.key \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}/UID=hsharame" \
	&& rm -rf /var/lib/apt/lists/*

COPY	conf/nginx.conf.template /etc/nginx/templates/nginx.conf.template

EXPOSE	443

CMD	["/bin/sh", "-c", "envsubst '$DOMAIN_NAME' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
