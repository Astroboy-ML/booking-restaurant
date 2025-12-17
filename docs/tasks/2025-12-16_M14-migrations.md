# Ticket: M14 — Baseline migrations PostgreSQL (restaurants + réservations)

## But
Introduire des migrations versionnées pour garantir un schéma reproductible incluant la table `reservations` et un socle `restaurants` pour différencier l’espace restaurateur.

## Scope
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

## Plan proposé
1) Ajouter la dépendance et la configuration de l’outil de migration.
2) Générer la migration initiale (tables restaurants + reservations, statut annulé/actif, FK) et brancher la commande dans compose/Makefile.
3) Documenter le flux complet (init, upgrade, reset) pour dev/CI ainsi que la gestion du restaurant par défaut.
