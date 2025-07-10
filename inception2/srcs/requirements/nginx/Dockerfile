FROM alpine:3.20

# Installation des paquets nécessaires
RUN apk update && apk add --no-cache \
    nginx \
    openssl

# Configuration du répertoire web
RUN mkdir -p /var/www/html && \
    adduser -u 82 -D -S -G www-data www-data && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Création du répertoire pour les certificats SSL
RUN mkdir -p /etc/nginx/ssl

# Génération des certificats SSL auto-signés
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=calberti.42.fr/UID=calberti"

# Configuration de NGINX
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Exposition du port 443
EXPOSE 443

# Démarrage de NGINX
ENTRYPOINT ["nginx", "-g", "daemon off;"]
