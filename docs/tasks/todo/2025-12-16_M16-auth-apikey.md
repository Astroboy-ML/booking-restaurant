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
- Vérifier que la clé n’apparaît pas dans le code, les logs ou les fixtures de test.
- Confirmer que les endpoints publics restent accessibles sans authentification.
- Harmoniser l’en-tête ou le paramètre utilisé (ex: `X-API-Key`) dans la doc et les tests.
