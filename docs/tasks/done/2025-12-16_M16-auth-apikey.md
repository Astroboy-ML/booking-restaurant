---
id: "2025-12-16_M16-auth-apikey"
title: "M16 Auth API key"
type: feature
area: backend
agents_required: [backend, security]
depends_on: ["2025-12-16_M0-foundation"]
validated_by: "marti"
validated_at: "2025-12-18"
---

## Contexte
L'API FastAPI expose des routes sensibles. Une protection par cle API configurable (header ou query) est demandee pour limiter l'acces tout en conservant des endpoints publics (health/metrics).

## Objectif
Ajouter une verification de cle API configurable et documentee, refuser les requetes non authentifiees, laisser les routes publiques ouvertes.

## Hors scope
- OAuth2/JWT ou schema d'auth plus complexe.
- Refonte des permissions metier.
- Gestion long terme des cles (secret manager hors ticket).

## Scope technique
- Dependence FastAPI pour valider la cle API.
- Parametrage via variables d'environnement/secrets.
- Choix des routes protegees vs publiques.
- Tests auto succes/echec + documentation d'usage.

## Contraintes
- Aucune cle en clair dans le depot; fournir via env/secret.
- Routes publiques (/health, /metrics) accessibles sans cle.
- Reponses explicites 401/403 selon absence ou cle invalide.

## Deliverables
- Verification API key dans l'API FastAPI.
- Variables de config documentees (cle + header/query).
- Tests unitaires/integ succes/echec + README.

## Criteres d'acceptation
- [x] Routes protegees renvoient 401/403 sans cle valide et 200 avec la bonne cle.
- [x] Cle injectee via configuration/secret (aucune valeur en clair dans le repo ni les tests).
- [x] Routes publiques (health/metrics) accessibles sans cle (teste).
- [x] Documentation explique la definition de la cle (env/secret) et son envoi (header ou query).

## Comment tester
1) Exporter une cle: `export API_KEY=test-key` (adapter pour PowerShell/Compose).
2) Lancer les tests: `make api-test` ou `cd apps/api && python -m pytest`.
3) Test manuel: `curl -H "X-API-Key: test-key" http://localhost:8000/reservations` puis sans header (attendu 401/403).
4) Verifier `/health` sans cle: `curl http://localhost:8000/health`.

## Plan
1) Ajouter la dependance FastAPI de verification de cle + config env.
2) Proteger les routes sensibles, laisser les publiques ouvertes; ajouter tests succes/echec.
3) Documenter l'utilisation de la cle (header/query) et la configuration (env/secret).

## A controler
- Resume: verification par cle API (header ou query) sur les routes de reservation; configuration via variables d'environnement; documentation mise a jour.
- Fichiers modifies: `apps/api/main.py`, `apps/api/app/security.py`, `apps/api/tests/conftest.py`, `apps/api/tests/test_api_key_auth.py`, `apps/api/README.md`.
- Commandes executees: `cd apps/api && python -m pytest` (6 passed, 6 skipped).
- AC: tout coche (401/403/200, cle via env, public ok, doc usage).
- Risques/rollback: faible; retirer `require_api_key` et le module `app/security.py` si besoin.
