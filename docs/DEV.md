# Developpement local

Workflow simple avec deux modes : front en local (`make dev`) ou front dans Docker (`make dev-docker`).

## Prerequis
- Docker Desktop
- Python 3.11+ (si vous lancez l'API hors Docker)
- Node.js 18+ (si vous lancez le front hors Docker)

## Commandes principales (Make)
- `make dev` : demarre Postgres + API + Adminer en Docker. Le front reste en local (commande ci-dessous). URLs affichees.
- `make dev-docker` : demarre Postgres + API + Adminer + front Vite en Docker. URLs affichees.
- `make dev-stop` : `docker compose -f docker-compose.dev.yml down`
- `make dev-reset` : `docker compose -f docker-compose.dev.yml down -v` puis relance `db api adminer` (front toujours en local).
- Qualite/tests : `make api-lint`, `make api-test`, `make web-lint`, `make web-test`, `make web-build`, `make api-migrate`.

## Modes de developpement
### Mode 1 : front en local (recommande DX)
1. Lancer l'API et la DB : `make dev`
2. Lancer le front : `cd apps/web && npm ci && npm run dev`
3. URLs :
   - API : http://localhost:8000 (docs : http://localhost:8000/docs)
   - Front : http://localhost:5173
   - Adminer : http://localhost:8080
   - DB : localhost:5432 (user=booking password=booking db=booking)
4. Variable front : creer `.env` dans `apps/web` avec `VITE_API_URL=http://localhost:8000`.

### Mode 2 : tout Docker (inclut le front)
1. Lancer : `make dev-docker`
2. URLs :
   - API : http://localhost:8000 (docs : http://localhost:8000/docs)
   - Front : http://localhost:5173
   - Adminer : http://localhost:8080
   - DB : localhost:5432 (user=booking password=booking db=booking)
3. Le service `web` utilise `VITE_API_URL=http://api:8000` pour parler a l'API dans le reseau Docker.

### Arret / reset
- Arret : `make dev-stop`
- Reset complet : `make dev-reset` (supprime les volumes Postgres). Relancer ensuite le front local si necessaire.

## Protocole de test rapide
1. `docker compose -f docker-compose.dev.yml ps` doit montrer `db`, `api`, `adminer` (et `web` si `dev-docker`).
2. API : `curl http://localhost:8000/health` (endpoint present dans apps/api/main.py) puis `curl http://localhost:8000/docs` (ou navigateur).
3. Front : ouvrir http://localhost:5173 (ou le port affiche par Vite en local).
4. Adminer : http://localhost:8080 (serveur `db`, user `booking`, password `booking`, base `booking`).
5. Tests : `make api-test` et `make web-test` (necessite deps installees).

## Notes
- Le front Docker monte le repo (`.:/app`) et un volume nomme `web_node_modules` pour eviter les problemes Windows.
- Les migrations Alembic sont lancees automatiquement au demarrage du service API via `alembic upgrade head`.
- Si le port 5173 est occupe en local, arreter les autres instances Vite ou utiliser `npm run dev -- --port 5174` (les URLs s'adaptent).
- `npm ci` est utilise car `apps/web/package-lock.json` est versionne pour garantir un install reproductible; si le lock etait absent il faudrait revenir a `npm install`.
