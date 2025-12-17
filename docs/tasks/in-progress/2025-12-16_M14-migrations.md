---
id: "2025-12-16_M14-migrations"
title: "M14 – Baseline migrations PostgreSQL (restaurants + reservations)"
type: feature
area: backend
agents_required: [backend, devops]
depends_on: []
validated_by:
validated_at:
---

## Contexte
Besoin de migrations versionnées pour garantir un schéma Postgres reproductible et faire cohabiter un socle `restaurants` avec les réservations existantes.

## Objectif
Introduire une première migration qui crée les tables `restaurants` et `reservations` (FK) avec un flux reproductible via une commande standard.

## Hors scope
- Refonte complète du modèle au-delà du MVP.
- Seed supplémentaire autre qu’un restaurant par défaut documenté pour le dev.

## Scope technique
- apps/api/ (config Alembic ou équivalent)
- docker-compose.yml (commande init)
- docs/DEV.md (section migrations)

## Contraintes
- Migration initiale couvrant `restaurants` (info minimale : id, name, contact/email optionnel) et `reservations` avec FK vers `restaurants` (nullable ou valeur par défaut pour un restaurant unique).
- Commandes reproductibles (`make api-migrate` par exemple).
- Pas de seed de données non nécessaire (au plus un restaurant par défaut documenté pour dev).

## Deliverables
- Config de l’outil de migration (fichiers env/alembic, scripts).
- Première migration créant les tables `restaurants` et `reservations` alignées avec le modèle actuel (champs MVP + FK restaurant + statut annulé/actif si inexistant).
- Documentation des commandes pour appliquer/réinitialiser les migrations en dev/CI et préciser la valeur par défaut du restaurant si utilisée.

## Critères d’acceptation
- [ ] La migration s’applique en local via une commande documentée et crée les deux tables avec la FK.
- [ ] Les tests d’intégration DB passent toujours après migration.
- [ ] docs/DEV.md explique comment lancer les migrations (dev et CI) et le comportement par défaut du restaurant lié.

## Comment tester
- Lancer `make api-migrate` (ou `cd apps/api && alembic -c alembic.ini upgrade head`) avec une DB Postgres disponible.
- Exécuter `python -m pytest apps/api/tests -m integration` après migration.
- Contrôler via psql/GUI que les tables `restaurants` et `reservations` existent avec la FK et le restaurant par défaut documenté.
- Relire `docs/DEV.md` pour les commandes dev/CI et la valeur par défaut du restaurant.

## Plan
1) Ajouter la dépendance et la configuration de l’outil de migration.
2) Générer la migration initiale (tables restaurants + reservations, statut annulé/actif, FK) et brancher la commande dans compose/Makefile.
3) Documenter le flux complet (init, upgrade, reset) pour dev/CI ainsi que la gestion du restaurant par défaut.

## À contrôler
- Résumé des changements appliqués.
- Fichiers modifiés et commits associés.
- Commandes exécutées (migrations, tests).
- Checklist AC et résultats observés.
- Risques/contournements connus.
- Plan de rollback (ex: downgrade, reset volume).
