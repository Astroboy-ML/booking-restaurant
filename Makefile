.PHONY: web-lint web-test web-build api-migrate api-migrate-revision docker-up docker-down

web-lint:
	cd apps/web && npm run lint

web-test:
	cd apps/web && npm run test

web-build:
	cd apps/web && npm run build

api-migrate:
	cd apps/api && alembic -c alembic.ini upgrade head

api-migrate-revision:
	cd apps/api && alembic -c alembic.ini revision -m "$(m)" --rev-id "$(rev)"

docker-up:
	docker compose up --build api db

docker-down:
	docker compose down
