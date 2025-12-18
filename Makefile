POWERSHELL ?= powershell
DEV_COMPOSE = docker-compose.dev.yml

.PHONY: web-lint web-test web-build api-lint api-test api-migrate api-migrate-revision dev dev-docker dev-stop dev-reset tf-fmt tf-validate tf-plan

TF ?= terraform
TF_DIR ?= infra/terraform
TF_BACKEND_BUCKET ?=
TF_BACKEND_REGION ?=
TF_BACKEND_DYNAMODB_TABLE ?=
TF_BACKEND_CONFIG ?= -backend=false
TF_INIT_FLAGS ?= -reconfigure
TF_INIT_BACKEND_OPTS := $(if $(TF_BACKEND_BUCKET),-backend-config="bucket=$(TF_BACKEND_BUCKET)") $(if $(TF_BACKEND_REGION),-backend-config="region=$(TF_BACKEND_REGION)") $(if $(TF_BACKEND_DYNAMODB_TABLE),-backend-config="dynamodb_table=$(TF_BACKEND_DYNAMODB_TABLE)")
TF_PLAN_ARGS ?=

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

tf-fmt:
	$(TF) -chdir=$(TF_DIR) fmt -check

tf-validate:
	$(TF) -chdir=$(TF_DIR) init $(if $(TF_BACKEND_BUCKET)$(TF_BACKEND_REGION)$(TF_BACKEND_DYNAMODB_TABLE),$(TF_INIT_BACKEND_OPTS),$(TF_BACKEND_CONFIG)) $(TF_INIT_FLAGS)
	$(TF) -chdir=$(TF_DIR) validate

tf-plan:
	$(TF) -chdir=$(TF_DIR) init $(if $(TF_BACKEND_BUCKET)$(TF_BACKEND_REGION)$(TF_BACKEND_DYNAMODB_TABLE),$(TF_INIT_BACKEND_OPTS),$(TF_BACKEND_CONFIG)) $(TF_INIT_FLAGS)
	$(TF) -chdir=$(TF_DIR) plan -input=false $(TF_PLAN_ARGS)
