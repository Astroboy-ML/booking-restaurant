POWERSHELL ?= powershell

.PHONY: web-lint web-test web-build api-lint api-test api-migrate api-migrate-revision docker-up docker-down dev

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

docker-up:
	docker compose up --build api db

docker-down:
        docker compose down

dev:
        $(POWERSHELL) -ExecutionPolicy Bypass -File scripts/dev.ps1
