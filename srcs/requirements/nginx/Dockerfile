FROM	debian:11.11

RUN	apt-get update && apt-get install -y \
	nginx \
	curl \
	openssl \
	&& mkdir -p /etc/nginx/ssl \
	&& mkdir -p /var/run/nginx \
	&& chmod 755 /var/www/html \
	&& chown -R www-data:www-data /var/www/html \
	&& openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt \
	-keyout /etc/nginx/ssl/inception.key \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=hsharame.42.fr/UID=hsharame" \
	&& rm -rf /var/lib/apt/lists/*

COPY	conf/nginx.conf /etc/nginx/conf.d

EXPOSE	443

CMD	[ "nginx", "-g", "daemon off;"]
