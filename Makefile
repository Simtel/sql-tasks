up: ##Docker up
	docker-compose up -d

down: ##Docker down
	docker-compose down --remove-orphans

down-clear: ##Docker down clear
	docker-compose down -v --remove-orphans

pull: ##Docker pull
	docker-compose pull

build: ##Docker build
	docker-compose build

console: ## Зайти в консоль mysql
	docker-compose exec db mysql -u root --password=example