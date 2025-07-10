FROM alpine:3.20

# Installation des dépendances
RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-phar \
    curl \
    mariadb-client

# Configuration PHP pour augmenter la limite de mémoire
RUN echo "memory_limit = 512M" >> /etc/php82/php.ini

# Création de l'utilisateur et du groupe www-data
RUN adduser -u 82 -D -S -G www-data www-data

# Installation de WordPress
WORKDIR /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configuration de PHP-FPM
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

# Script d'initialisation
COPY tools/wp-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp-setup.sh

# Permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp-setup.sh"]
