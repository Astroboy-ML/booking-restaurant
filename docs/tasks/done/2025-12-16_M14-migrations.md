---
id: "2025-12-16_M14-migrations"
title: "M14 Migrations initiales (restaurants + reservations)"
type: feature
area: backend
agents_required: [backend, devops]
depends_on: ["2025-12-16_M2-postgres-persistence"]
validated_by:
validated_at:
---

## Contexte
Mettre en place des migrations versionnees pour Postgres (tables restaurants et reservations) et une commande standard.

## Realise
- Alembic configure, migration initiale cree les tables avec FK et seed restaurant par defaut.
- Commande `make api-migrate` applique l'upgrade.
- UI Adminer ajoutee pour verifier la base.

## Ecarts / risques
- Encodage corrige; front matter normalise.
- Makefile manque toujours les cibles api-test/api-lint.

## Criteres d'acceptation
- [x] Migration appliquee en local via commande documentee
- [x] Deux tables creees avec FK
- [x] Tests d'integration DB passent apres migration
- [x] Documentation migrations dans docs/DEV.md
