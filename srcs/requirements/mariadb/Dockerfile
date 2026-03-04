FROM	debian:11.11

RUN	apt update && apt install -y \
	mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY	tools/create-db.sh /usr/local/bin/create-db.sh

RUN	chmod +x /usr/local/bin/create-db.sh

RUN mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
	&& chmod 750 /var/lib/mysql /var/run/mysqld

#RUN	mariadb-install-db --user=mysql --datadir=/var/lib/mysql --basedir=/usr

EXPOSE	3306

CMD	["bash", "/usr/local/bin/create-db.sh"]
