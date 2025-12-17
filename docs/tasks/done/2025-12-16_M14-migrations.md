---
id: "2025-12-16_M14-migrations"
title: "M14 ƒ?" Baseline migrations PostgreSQL (restaurants + reservations)"
type: feature
area: backend
agents_required: [backend, devops]
depends_on: []
validated_by:
validated_at:
---

## Contexte
Besoin de migrations versionnÇ¸es pour garantir un schÇ¸ma Postgres reproductible et faire cohabiter un socle `restaurants` avec les rÇ¸servations existantes.

## Objectif
Introduire une premiÇùre migration qui crÇ¸e les tables `restaurants` et `reservations` (FK) avec un flux reproductible via une commande standard.

## Hors scope
- Refonte complÇùte du modÇùle au-delÇÿ du MVP.
- Seed supplÇ¸mentaire autre quƒ?Tun restaurant par dÇ¸faut documentÇ¸ pour le dev.

## Scope technique
- apps/api/ (config Alembic ou Ç¸quivalent)
- docker-compose.yml (commande init)
- docs/DEV.md (section migrations)

## Contraintes
- Migration initiale couvrant `restaurants` (info minimale : id, name, contact/email optionnel) et `reservations` avec FK vers `restaurants` (nullable ou valeur par dÇ¸faut pour un restaurant unique).
- Commandes reproductibles (`make api-migrate` par exemple).
- Pas de seed de donnÇ¸es non nÇ¸cessaire (au plus un restaurant par dÇ¸faut documentÇ¸ pour dev).

## Deliverables
- Config de lƒ?Toutil de migration (fichiers env/alembic, scripts).
- PremiÇùre migration crÇ¸ant les tables `restaurants` et `reservations` alignÇ¸es avec le modÇ¸le actuel (champs MVP + FK restaurant + statut annulÇ¸/actif si inexistant).
- Documentation des commandes pour appliquer/rÇ¸initialiser les migrations en dev/CI et prÇ¸ciser la valeur par dÇ¸faut du restaurant si utilisÇ¸e.

## CritÇùres dƒ?Tacceptation
- [x] La migration sƒ?Tapplique en local via une commande documentÇ¸e et crÇ¸e les deux tables avec la FK.
- [x] Les tests dƒ?TintÇ¸gration DB passent toujours aprÇùs migration.
- [x] docs/DEV.md explique comment lancer les migrations (dev et CI) et le comportement par dÇ¸faut du restaurant liÇ¸.

## Comment tester
- Lancer `make api-migrate` (ou `cd apps/api && alembic -c alembic.ini upgrade head`) avec une DB Postgres disponible.
- ExÇ¸cuter `python -m pytest apps/api/tests -m integration` aprÇùs migration.
- ContrÇïler via psql/GUI que les tables `restaurants` et `reservations` existent avec la FK et le restaurant par dÇ¸faut documentÇ¸.
- Relire `docs/DEV.md` pour les commandes dev/CI et la valeur par dÇ¸faut du restaurant.

## Plan
1) Ajouter la dÇ¸pendance et la configuration de lƒ?Toutil de migration.
2) GÇ¸nÇ¸rer la migration initiale (tables restaurants + reservations, statut annulÇ¸/actif, FK) et brancher la commande dans compose/Makefile.
3) Documenter le flux complet (init, upgrade, reset) pour dev/CI ainsi que la gestion du restaurant par dÇ¸faut.

## Ç? contrÇïler
- RÇ¸sumÇ¸ des changements appliquÇ¸s.
- Fichiers modifiÇ¸s et commits associÇ¸s.
- Commandes exÇ¸cutÇ¸es (migrations, tests).
- Checklist AC et rÇ¸sultats observÇ¸s.
- Risques/contournements connus.
- Plan de rollback (ex: downgrade, reset volume).
