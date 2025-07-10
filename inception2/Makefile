NAME = inception

# Chemins des volumes
WORDPRESS_PATH = /home/calberti/data/wordpress
MARIADB_PATH = /home/calberti/data/mariadb

all: prepare build up

prepare:
	@echo "Création des répertoires pour les volumes..."
	@sudo mkdir -p $(WORDPRESS_PATH)
	@sudo mkdir -p $(MARIADB_PATH)
	@sudo chown -R 82:82 $(WORDPRESS_PATH)
	@sudo chown -R 999:999 $(MARIADB_PATH)
	@sudo chmod 755 $(WORDPRESS_PATH)
	@sudo chmod 755 $(MARIADB_PATH)

build:
	@echo "Construction des images Docker..."
	@cd srcs && docker-compose build

up:
	@echo "Démarrage des conteneurs..."
	@cd srcs && docker-compose up -d

down:
	@echo "Arrêt des conteneurs..."
	@cd srcs && docker-compose down

clean: down
	@echo "Nettoyage des conteneurs et des images..."
	@docker system prune -a --force
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

fclean: clean
	@echo "Suppression des volumes..."
	@sudo rm -rf /home/calberti/data
	@sudo mkdir -p $(WORDPRESS_PATH)
	@sudo mkdir -p $(MARIADB_PATH)
	@sudo chown -R 82:82 $(WORDPRESS_PATH)
	@sudo chown -R 999:999 $(MARIADB_PATH)
	@sudo chmod 755 $(WORDPRESS_PATH)
	@sudo chmod 755 $(MARIADB_PATH)

re: fclean all

ps:
	@cd srcs && docker-compose ps

logs:
	@cd srcs && docker-compose logs

.PHONY: all prepare build up down clean fclean re ps logs