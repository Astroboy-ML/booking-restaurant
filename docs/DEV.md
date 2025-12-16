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

1) Créer le cluster kind (ports 80/443 mappés pour l'Ingress)  
`kind create cluster --name booking --config k8s/local-kind/kind-config.yaml`

2) Installer ingress-nginx (manifest officiel kind)  
`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml`  
Attendre que le contrôleur soit Ready :  
`kubectl wait --namespace ingress-nginx --for=condition=Ready pod -l app.kubernetes.io/component=controller --timeout=180s`

3) Builder l’image API locale  
`docker build -t booking-api:local apps/api`

4) Charger l’image dans kind  
`kind load docker-image booking-api:local --name booking`

5) Appliquer les manifests K8s (namespace booking, Postgres emptyDir, API, Ingress)  
`kubectl apply -k k8s`

6) Vérifier les ressources  
`kubectl get pods -n booking`  
`kubectl get ingress -n booking`

7) Attendre la disponibilité des pods  
`kubectl -n booking wait --for=condition=Ready pod -l app=postgres --timeout=120s`  
`kubectl -n booking wait --for=condition=Ready pod -l app=api --timeout=120s`

8) Tester via Ingress (pas de port-forward)  
`curl http://localhost/health`  
`curl -X POST http://localhost/reservations -H "Content-Type: application/json" -d '{"name":"Bob","date_time":"2025-01-01T19:00:00Z","party_size":2}'`  
`curl http://localhost/reservations`
`curl http://localhost/metrics`  # endpoint Prometheus, ne pas exposer en prod

> Note Windows (PowerShell) : l'alias `curl` pointe vers `Invoke-WebRequest`. Utilisez `curl.exe` ou `Invoke-RestMethod` pour tester `/health` et les endpoints JSON.

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
 - Ingress :
   - `kubectl get ingress -n booking`
   - `kubectl -n ingress-nginx get pods`
   - `kubectl -n ingress-nginx logs deploy/ingress-nginx-controller`
