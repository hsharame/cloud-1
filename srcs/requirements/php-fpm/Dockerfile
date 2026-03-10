FROM	debian:bookworm

RUN	apt update && apt install -y \
	wget \
	php \
	php-fpm \
	php-mysql \
	&& rm -rf /var/lib/apt/lists/* 
	
RUN	wget https://fr.wordpress.org/wordpress-6.8-fr_FR.tar.gz -P /var/www \
	&& cd /var/www && tar -xzf wordpress-6.8-fr_FR.tar.gz \
	&& rm wordpress-6.8-fr_FR.tar.gz \
	&& chown -R www-data:www-data /var/www/wordpress

COPY	conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN	mkdir -p /run/php

ENTRYPOINT ["php-fpm8.2", "-F"]
