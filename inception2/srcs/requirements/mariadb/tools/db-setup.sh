#!/bin/sh

# Initialisation de la base de données si elle n'existe pas
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Initialisation de MariaDB
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Démarrage temporaire de MariaDB
    mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

# Démarrage de MariaDB
exec mysqld --user=mysql --console
