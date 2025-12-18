POWERSHELL ?= powershell
DEV_COMPOSE = docker-compose.dev.yml

.PHONY: web-lint web-test web-build api-lint api-test api-migrate api-migrate-revision dev dev-docker dev-stop dev-reset tf-fmt tf-validate tf-plan ecr-login docker-build-api docker-push-api docker-build-web docker-push-web

TF ?= terraform
TF_DIR ?= infra/terraform
TF_BACKEND_BUCKET ?=
TF_BACKEND_REGION ?=
TF_BACKEND_DYNAMODB_TABLE ?=
TF_BACKEND_CONFIG ?= -backend=false
TF_INIT_FLAGS ?= -reconfigure
TF_INIT_BACKEND_OPTS := $(if $(TF_BACKEND_BUCKET),-backend-config="bucket=$(TF_BACKEND_BUCKET)") $(if $(TF_BACKEND_REGION),-backend-config="region=$(TF_BACKEND_REGION)") $(if $(TF_BACKEND_DYNAMODB_TABLE),-backend-config="dynamodb_table=$(TF_BACKEND_DYNAMODB_TABLE)")
TF_PLAN_ARGS ?=

AWS_REGION ?=
ECR_REGISTRY ?=
ECR_REPO_API ?= booking-api
ECR_REPO_WEB ?=
IMAGE_TAG ?= $(shell git rev-parse --short HEAD)
PUBLISH_LATEST ?= false

API_IMAGE := $(ECR_REGISTRY)/$(ECR_REPO_API)
WEB_IMAGE := $(ECR_REGISTRY)/$(ECR_REPO_WEB)

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

ecr-login:
	$(if $(AWS_REGION),,$(error AWS_REGION is required))
	$(if $(ECR_REGISTRY),,$(error ECR_REGISTRY is required (ex: <account>.dkr.ecr.<region>.amazonaws.com)))
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_REGISTRY)

docker-build-api:
	$(if $(ECR_REGISTRY),,$(error ECR_REGISTRY is required for API image tagging))
	$(if $(ECR_REPO_API),,$(error ECR_REPO_API is required))
	DOCKER_BUILDKIT=1 docker build -f apps/api/Dockerfile -t $(API_IMAGE):$(IMAGE_TAG) .

docker-push-api:
	$(if $(ECR_REGISTRY),,$(error ECR_REGISTRY is required for API image pushing))
	$(if $(ECR_REPO_API),,$(error ECR_REPO_API is required))
	docker push $(API_IMAGE):$(IMAGE_TAG)
ifeq ($(PUBLISH_LATEST),true)
	docker tag $(API_IMAGE):$(IMAGE_TAG) $(API_IMAGE):latest
	docker push $(API_IMAGE):latest
endif

docker-build-web:
	$(if $(ECR_REGISTRY),,$(error ECR_REGISTRY is required for web image tagging))
	$(if $(ECR_REPO_WEB),,$(error ECR_REPO_WEB is required for web image tagging))
	DOCKER_BUILDKIT=1 docker build -f apps/web/Dockerfile -t $(WEB_IMAGE):$(IMAGE_TAG) .

docker-push-web:
	$(if $(ECR_REGISTRY),,$(error ECR_REGISTRY is required for web image pushing))
	$(if $(ECR_REPO_WEB),,$(error ECR_REPO_WEB is required for web image pushing))
	docker push $(WEB_IMAGE):$(IMAGE_TAG)
ifeq ($(PUBLISH_LATEST),true)
	docker tag $(WEB_IMAGE):$(IMAGE_TAG) $(WEB_IMAGE):latest
	docker push $(WEB_IMAGE):latest
endif
