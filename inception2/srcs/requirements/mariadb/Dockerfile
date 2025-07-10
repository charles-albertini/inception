FROM alpine:3.20

# Installation de MariaDB
RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client

# Configuration des répertoires et permissions
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

# Configuration de MariaDB
COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

# Script d'initialisation
COPY tools/db-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/db-setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/db-setup.sh"]
