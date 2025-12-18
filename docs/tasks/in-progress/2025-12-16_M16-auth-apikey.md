---
id: "2025-12-16_M16-auth-apikey"
title: "M16 Auth API key"
type: feature
area: backend
agents_required: [backend, security]
depends_on: ["2025-12-16_M0-foundation"]
validated_by:
validated_at:
---

## Contexte
L’API FastAPI expose des endpoints potentiellement sensibles sans authentification dédiée. Une protection par clé API est demandée pour contrôler l’accès aux routes sécurisées.

## Objectif
Ajouter une authentification par clé API configurable (header ou query param) qui refuse les requêtes non authentifiées tout en laissant ouverts les endpoints publics (health/metrics si souhaité).

## Hors scope
- Mise en place d’OAuth2/JWT ou d’autres schémas d’authentification plus complexes.
- Refonte complète des permissions métier (se limiter au périmètre routes sensibles défini).
- Gestion/stockage long terme des clés (couverte par le ticket secrets si besoin).

## Scope technique
- Middleware ou dépendance FastAPI pour vérifier la clé API.
- Paramétrage via variables d’environnement/Secrets (pas de clé en clair dans le code).
- Sélection des endpoints protégés vs publics (health/metrics).
- Tests automatisés (succès/échec) et documentation d’usage.

## Contraintes
- Aucune clé en clair dans le dépôt ; clé fournie via env/secret store.
- Routes publiques (ex: `/health`, `/metrics`) restent accessibles sans clé.
- Réponses d’erreur explicites (401/403) en cas d’absence ou clé invalide.

## Deliverables
- Implémentation de la vérification API key dans l’API FastAPI.
- Variables de configuration (env/settings) documentées pour la clé et le header utilisé.
- Tests unitaires/integ couvrant succès/échec + documentation (README ou docs/DEV.md).

## Critères d’acceptation
- [ ] Les endpoints protégés retournent 401/403 sans clé valide ; 200 avec la clé correcte.
- [ ] La clé est injectée via configuration/secret (pas de valeur en clair dans le repo ni dans les tests).
- [ ] Les endpoints publics (health/metrics) restent accessibles sans clé (vérifié par test).
- [ ] La documentation précise comment définir la clé (env/secret) et comment l’envoyer côté client (header ou query param).

## Comment tester
1) Définir une clé de test : `export API_KEY=test-key` (ou via dotenv/secret manager selon implémentation).
2) Lancer les tests : `make api-test` (ou `cd apps/api && python -m pytest`).
3) Test manuel : `curl -H "X-API-Key: test-key" http://localhost:8000/endpoint-protege` (doit répondre 200) puis sans header (doit répondre 401/403).
4) Vérifier qu’un endpoint public (ex: `/health`) répond sans clé : `curl http://localhost:8000/health`.

## Plan
1) Ajouter la dépendance/middleware FastAPI pour valider la clé API + configuration dans les settings/env.
2) Protéger les routes sensibles, laisser les routes publiques accessibles ; ajouter les tests succès/échec.
3) Documenter l’utilisation de la clé (header/paramètre) et la configuration côté déploiement (env/secret).

## À contrôler
- Résumé : ajout d’une vérification par clé API (header ou query) sur les routes de réservation, avec configuration via variables d’environnement et documentation d’usage.
- Fichiers modifiés : `apps/api/main.py`, `apps/api/app/security.py`, `apps/api/tests/conftest.py`, `apps/api/tests/test_api_key_auth.py`, `apps/api/README.md`.
- Commandes exécutées : `cd apps/api && python -m pytest` (6 passed, 6 skipped).
- AC :
  - [x] Endpoints protégés renvoient 401/403 sans clé valide et 200 avec la clé correcte (tests `test_api_key_auth.py`).
  - [x] Clé injectée via configuration/secret : lecture `API_KEY` depuis l’environnement, aucune valeur sensible en dur.
  - [x] Endpoints publics accessibles sans clé (tests health/metrics). 
  - [x] Documentation mise à jour avec configuration et usage du header/query param (`apps/api/README.md`).
- Risques/rollback : faible ; supprimer les dépendances d’auth dans `apps/api/main.py` et retirer le module `app/security.py` pour revenir au comportement précédent.
