FROM    debian:bookworm

RUN     apt update && apt install -y \
        wget \
        php-cli \
        php-mysql \
        mariadb-client \
        && rm -rf /var/lib/apt/lists/*

RUN	mkdir -p /var/www \
	&& wget https://fr.wordpress.org/wordpress-6.8-fr_FR.tar.gz -P /tmp \
    	&& tar -xzf /tmp/wordpress-6.8-fr_FR.tar.gz -C /var/www \
    	&& rm /tmp/wordpress-6.8-fr_FR.tar.gz \
    	&& chown -R www-data:www-data /var/www/wordpress

RUN     wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        && chmod +x wp-cli.phar \
        && mv wp-cli.phar /usr/local/bin/wp

COPY    tools/auto-config.sh /usr/local/bin/auto-config.sh

RUN     chmod +x /usr/local/bin/auto-config.sh

ENTRYPOINT ["/usr/local/bin/auto-config.sh"]
