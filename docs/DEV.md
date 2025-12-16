# DEV – Développement local

## Objectif
Source de vérité pour lancer et vérifier le projet en local.

## Pré-requis
- Git
- Docker Desktop (avec support Kubernetes/Docker)
- Python 3.11+ (pour l’API) ou usage exclusif via Docker
- Node.js 18+ (pour le front) ou usage exclusif via Docker
- kubectl
- kind

> AWS/Terraform viendront plus tard (phase cloud).

## Commandes « officielles » attendues
Objectif : standardiser via Makefile (ou scripts si nécessaire sur Windows).

API  
- Lint : `make api-lint`  
- Tests : `make api-test`

Web  
- Lint : `make web-lint`  
- Tests : `make web-test`

Docker  
- Build images : `make docker-build`  
- Run local (compose) : `make docker-up`  
- Stop : `make docker-down`

Kubernetes local (kind)  
- Créer cluster : `make kind-up`  
- Supprimer cluster : `make kind-down`  
- Déployer manifests : `make k8s-apply`  
- Détruire manifests : `make k8s-destroy`

Terraform (phase AWS)  
- `make tf-fmt`  
- `make tf-validate`  
- `make tf-plan`  
- `make tf-apply`

## Démarrage rapide API (compose)
- Lancer Postgres + API : `docker compose up --build api db`
- Arrêter : `docker compose down`
- L’API expose `/health`.
- La connexion utilise `DATABASE_URL` (par défaut `postgresql://booking:booking@db:5432/booking` en compose).
- Endpoints principaux : `POST /reservations` (création), `GET /reservations` (liste, trié par id asc), `DELETE /reservations/{id}` (204 ou 404 si absent).

## Tests API (pytest)
- Installer les dépendances : `pip install -r apps/api/requirements.txt`
- Exécuter les tests : `python -m pytest apps/api/tests`
- Les tests marqués `integration` sont skippés automatiquement si la DB est indisponible : `python -m pytest apps/api/tests -m integration`

## Déploiement local sur kind (API + Postgres)
Prérequis : Docker, kind, kubectl.

1) Créer le cluster kind  
`kind create cluster --name booking`

2) Builder l’image API locale (exemple rapide)  
```
docker build -t booking-api:local -f - . <<'EOF'
FROM python:3.11-slim
WORKDIR /app
COPY apps/api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY apps/api /app/apps/api
ENV PYTHONUNBUFFERED=1
CMD ["uvicorn", "apps.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF
```

3) Charger l’image dans kind  
`kind load docker-image booking-api:local --name booking`

4) Appliquer les manifests K8s (namespace booking, Postgres emptyDir, API)  
`kubectl apply -k k8s`

5) Vérifier les pods  
`kubectl get pods -n booking`

6) Exposer l’API en local (port-forward)  
`kubectl port-forward -n booking svc/api 8000:8000`

7) Tester  
- `curl http://localhost:8000/health`  
- `curl -X POST http://localhost:8000/reservations -H "Content-Type: application/json" -d '{"name":"Bob","date_time":"2025-01-01T19:00:00Z","party_size":2}'`  
- `curl http://localhost:8000/reservations`

## Conventions
- Toute nouvelle commande de dev doit être ajoutée ici.
- Toute étape de « mise en route » doit être reproductible depuis un repo propre.

## Debug
- Logs K8s :
  - `kubectl get pods`
  - `kubectl describe pod <pod>`
  - `kubectl logs <pod>`
- Santé API :
  - endpoint `/health` (utilisé pour readiness/liveness probes)
