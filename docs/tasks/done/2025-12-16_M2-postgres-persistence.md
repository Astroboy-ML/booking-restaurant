---
id: "2025-12-16_M2-postgres-persistence"
title: "M2 Persistance Postgres"
type: feature
area: backend
agents_required: [backend]
depends_on: ["2025-12-16_M1-create-reservation"]
validated_by:
validated_at:
---

## Contexte
Brancher la persistance Postgres pour stocker les reservations.

## Realise
- Repository psycopg avec operations CRUD de base.
- Migration initiale creant tables restaurants et reservations, seed restaurant par defaut.
- Tests d'integration connectant la base.

## Ecarts / risques
- Cible Makefile api-test/api-lint absente (alignement CI manquant).
- Doc URL DB peu reliee aux commandes Makefile.

## Criteres d'acceptation
- [x] Tables creees pour restaurants et reservations avec FK
- [x] Seed restaurant par defaut present
- [x] Tests d'integration DB passent avec la migration
- [ ] Cible Makefile pour tests/lint alignes sur la CI
