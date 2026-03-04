FROM	debian:11.11

RUN	apt update && apt install -y \
	wget \
	php7.4 \
	php-fpm \
	php-mysql \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/* 
	
RUN	wget https://fr.wordpress.org/wordpress-6.8-fr_FR.tar.gz -P /var/www \
	&& cd /var/www && tar -xzf wordpress-6.8-fr_FR.tar.gz \
	&& rm wordpress-6.8-fr_FR.tar.gz \
	&& chown -R root:root /var/www/wordpress

RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY	conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY	tools/auto-config.sh /usr/local/bin/auto-config.sh

RUN	chmod +x /usr/local/bin/auto-config.sh

RUN	mkdir -p /run/php

ENTRYPOINT ["/usr/local/bin/auto-config.sh"]
