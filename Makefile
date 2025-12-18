POWERSHELL ?= powershell
DEV_COMPOSE = docker-compose.dev.yml

.PHONY: web-lint web-test web-build api-lint api-test api-migrate api-migrate-revision dev dev-docker dev-stop dev-reset

web-lint:
	cd apps/web && npm run lint

web-test:
	cd apps/web && npm run test

web-build:
	cd apps/web && npm run build

api-lint:
	cd apps/api && ruff check . && ruff format --check .

api-test:
	cd apps/api && python -m pytest

api-migrate:
	cd apps/api && alembic -c alembic.ini upgrade head

api-migrate-revision:
	cd apps/api && alembic -c alembic.ini revision -m "$(m)" --rev-id "$(rev)"

# Mode dev : DB+API+Adminer via compose, front lance en local (vite)
dev:
	docker compose -f $(DEV_COMPOSE) up -d db api adminer
	@echo "API      : http://localhost:8000 (docs: /docs)"
	@echo "Adminer  : http://localhost:8080"
	@echo "DB       : localhost:5432 (user=booking password=booking db=booking)"
	@echo "Front    : lancer 'cd apps/web && npm install && npm run dev'"
	@echo "Front URL: http://localhost:5173"

# Mode full docker : DB+API+Adminer+Front via compose
dev-docker:
	docker compose -f $(DEV_COMPOSE) up -d
	@echo "API      : http://localhost:8000 (docs: /docs)"
	@echo "Front    : http://localhost:5173"
	@echo "Adminer  : http://localhost:8080"
	@echo "DB       : localhost:5432 (user=booking password=booking db=booking)"

# Stoppe tous les services (sans supprimer les volumes)
dev-stop:
	docker compose -f $(DEV_COMPOSE) down

# Reset complet (volumes supprimes) puis relance DB+API+Adminer
dev-reset:
	docker compose -f $(DEV_COMPOSE) down -v
	docker compose -f $(DEV_COMPOSE) up -d db api adminer
	@echo "API      : http://localhost:8000 (docs: /docs)"
	@echo "Adminer  : http://localhost:8080"
	@echo "DB       : localhost:5432 (user=booking password=booking db=booking)"
	@echo "Front    : lancer 'cd apps/web && npm install && npm run dev'"
	@echo "Front URL: http://localhost:5173"
