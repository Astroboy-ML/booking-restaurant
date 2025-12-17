---
id: "2025-12-16_M0-foundation"
title: "M0 Foundation (health, compose, CI)"
type: feature
area: backend
agents_required: [backend]
depends_on: []
validated_by:
validated_at:
---

## Contexte
Mettre en place les bases du repo API : endpoint de sante, tests, et environnement local reproductible.

## Realise
- Endpoint GET /health retourne 200 avec test automatique.
- Docker Compose lance Postgres + API en local.
- Documentation mentionne comment lancer via compose.
- Workflow CI present pour lint/tests.

## Ecarts / risques
- Makefile ne fournit pas encore les cibles api-test/api-lint alignees sur la CI.

## Criteres d'acceptation
- [x] API : endpoint GET /health retourne 200
- [x] API : au moins un test automatise pour /health
- [x] Docker Compose : lance Postgres + API en local
- [x] Documentation : indique comment lancer et tester
- [x] CI : un workflow executant lint + tests API
