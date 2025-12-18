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
- Migrations : `make api-migrate`
- Dev complet (DB + API + Web) : `make dev` (démarre Postgres via docker compose, applique les migrations, lance uvicorn --reload et Vite)

Web  
- Lint : `make web-lint`  
- Tests : `make web-test`
> Front : `make` se place dans `apps/web` avant d’exécuter les scripts npm.

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
- La connexion utilise `DATABASE_URL` (par défaut `postgresql+psycopg://booking:booking@db:5432/booking` en compose).
- Endpoints principaux : `POST /reservations` (création), `GET /reservations` (liste, trié par id asc), `DELETE /reservations/{id}` (204 ou 404 si absent).
- Uvicorn : par défaut `UVICORN_HOST` vaut `127.0.0.1` pour les runs locaux ; en container, définis `UVICORN_HOST=0.0.0.0` pour écouter sur toutes les interfaces.

## Migrations Postgres (Alembic)
- Compose : les migrations Alembic sont appliquées automatiquement avant de lancer l’API.
- Appliquer toutes les migrations (dev/CI) : `make api-migrate` (ou `cd apps/api && alembic -c alembic.ini upgrade head`).
- Créer une nouvelle révision (nom court + identifiant explicite) :  
  `make api-migrate-revision m="add new field" rev="202512171300"`  
  puis `make api-migrate`.
- Valeur par défaut : une entrée `restaurants` avec `id=1`, `name='Default Restaurant'` est créée lors de la migration initiale ; les réservations utilisent `restaurant_id` par défaut `1` (pas de seed supplémentaire).
- Reset local rapide : `docker compose down -v` pour supprimer les volumes Postgres puis `make api-migrate`.

## Tests API (pytest)
- Installer les dépendances : `pip install -r apps/api/requirements.txt`
- Exécuter les tests : `python -m pytest apps/api/tests`
- Les tests marqués `integration` sont skippés automatiquement si la DB est indisponible : `python -m pytest apps/api/tests -m integration`

## Qualité / Sécurité (local)
- Installer les dépendances dev : `py -m pip install -r apps/api/requirements.txt -r apps/api/requirements-dev.txt` (ou `python -m pip ...`)
- Installer pre-commit : `py -m pre-commit install`
- Lancer Ruff (lint + format check) :  
  `cd apps/api && ruff check .`  
  `cd apps/api && ruff format --check .`
- Lancer Bandit : `cd apps/api && bandit -r . -c pyproject.toml`
- Lancer pip-audit : `cd apps/api && pip-audit -r requirements.txt`
- (Optionnel) Trivy image locale :  
  `docker build -t booking-api:ci apps/api`  
  `trivy image --severity HIGH,CRITICAL --exit-code 1 booking-api:ci`

## Frontend (web)
- Node 18+ requis (cf. `.nvmrc` et `package.json` → `engines.node >= 18`).  
- Dépendances : `cd apps/web && npm install`.  
- Variables d’environnement : copier `.env.example` en `.env`, renseigner `VITE_API_URL` (non hardcodée dans le code, lue via `src/config.ts`).  
- Lancement dev : `cd apps/web && npm run dev`.  
- Lint : `make web-lint` ou `cd apps/web && npm run lint`.  
- Tests one-shot : `make web-test` ou `cd apps/web && npm run test` (Vitest run, jsdom, setup RTL).  
- Tests watch : `cd apps/web && npm run test:watch`.  
- Build : `make web-build` ou `cd apps/web && npm run build`.

## Dev complet (happy path)

Approche principale (DX) : DB dans Docker, API + front en local.

- Démarrer l'environnement : `make dev` (ou `pwsh -File scripts/dev.ps1`).
  - Pré-requis : Docker Desktop lancé, `python` et `npm` disponibles, dépendances déjà installées (`pip install -r apps/api/requirements.txt`, `npm install` dans `apps/web`).
  - Ce que la commande fait : `docker compose up -d db` (attend le healthcheck Postgres), applique les migrations Alembic, lance l'API FastAPI en reload et le front Vite, puis affiche les URLs utiles.
- Arrêter : `docker compose down` (ou `Ctrl+C` puis `docker compose down`).
- Reset complet (DB vide) : `docker compose down -v` puis `make dev`.
- URLs affichées :
  - API : http://localhost:8000
  - API docs : http://localhost:8000/docs
  - Front : http://localhost:5173 (VITE_API_URL pointant sur l'API)
  - DB : localhost:5432 (booking/booking)

Option alternative (tout Docker) : `docker compose up --build api db adminer` (front non inclus dans compose aujourd'hui). Utile si vous ne voulez pas installer Python/Node localement, mais le flux principal reste l'option DB Docker + services locaux pour le DX.

### Appels API front (reservations)
- Base URL : `VITE_API_URL` (ex: `http://localhost:8000` ? port backend, pas 5173).
- Endpoints utilises : `GET /reservations`, `POST /reservations`.
- Payload POST attendu (datetime tel que saisi dans le champ `datetime-local`, pas de conversion automatique) :
  ```json
  {
    "name": "Alice",
    "date_time": "2025-01-01T19:00",
    "party_size": 2
  }
  ```

> Déploiement statique : l’app utilise `BrowserRouter`. Prévoir un fallback vers `index.html` sur toutes les routes (`/client`, `/restaurateur`) pour éviter les 404 en refresh côté serveur/CDN.

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
 - `make dev` : démarre DB docker compose, applique les migrations Alembic, lance l'API (uvicorn --reload) et le front (Vite --host) avec affichage des URLs.

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
