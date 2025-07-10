#!/bin/sh

# Attendre que MariaDB soit prêt
while ! mysqladmin ping -h mariadb --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

echo "MariaDB is ready!"

# Télécharger WordPress si ce n'est pas déjà fait
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Setting up WordPress..."
    
    # S'assurer que le répertoire est vide
    rm -rf /var/www/html/*
    
    cd /var/www/html
    
    # Utiliser php82 pour wp-cli avec plus de mémoire
    echo "Downloading WordPress core..."
    /usr/bin/php82 -d memory_limit=512M /usr/local/bin/wp core download --allow-root
    
    if [ $? -ne 0 ]; then
        echo "Failed to download WordPress core"
        exit 1
    fi

    echo "Creating WordPress configuration..."
    # Créer la configuration WordPress
    /usr/bin/php82 -d memory_limit=512M /usr/local/bin/wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost=mariadb \
        --allow-root
    
    if [ $? -ne 0 ]; then
        echo "Failed to create WordPress configuration"
        exit 1
    fi

    echo "Installing WordPress..."
    # Installer WordPress
    /usr/bin/php82 -d memory_limit=512M /usr/local/bin/wp core install \
        --url=https://calberti.42.fr \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
    
    if [ $? -ne 0 ]; then
        echo "Failed to install WordPress"
        exit 1
    fi

    echo "Creating additional user..."
    # Créer un utilisateur supplémentaire
    /usr/bin/php82 -d memory_limit=512M /usr/local/bin/wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    echo "Setting correct permissions..."
    # S'assurer que les permissions sont correctes
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    
    echo "WordPress setup completed successfully!"
else
    echo "WordPress is already configured."
fi

echo "Starting PHP-FPM..."
# Démarrer PHP-FPM
exec /usr/sbin/php-fpm82 -F
