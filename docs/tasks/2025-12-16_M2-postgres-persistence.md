# Ticket: M2 — Persist reservations in PostgreSQL (API + tests)

## But
Remplacer le stockage in-memory par une persistance PostgreSQL pour les réservations.

## Scope
- apps/api/
- docker-compose.yml (si besoin)
- docs/DEV.md (si commandes changent)

## Contraintes
- Rester minimal (pas d’auth, pas de features en plus)
- Pas d’ORM complexe si non nécessaire (mais utiliser un outil standard est OK)
- Pas de migrations “magiques” : la création de table doit être reproductible
- Pas de secrets dans Git (utiliser env vars)

## Spécification DB (minimale)
Table `reservations` :
- id (PK)
- name (text)
- date_time (timestamp)
- party_size (int)
- created_at (timestamp, optionnel)

## API attendue
- POST /reservations : crée en DB et retourne l’objet créé
- (Optionnel pour M2 si déjà fait plus tard) GET /reservations : liste depuis DB

## Configuration
- Utiliser des variables d’environnement (DATABASE_URL ou host/user/password/dbname)
- Docker Compose doit fournir les variables nécessaires pour API + Postgres

## Tests (important)
- Les tests doivent continuer à passer.
- Ajouter au moins 1 test d’intégration DB :
  - création réservation → persiste → récupérable (selon endpoints disponibles)
- Les tests doivent être automatisables en CI.

## Critères d’acceptation
- [ ] L’API écrit/relit les réservations depuis PostgreSQL (plus d’in-memory)
- [ ] Le schéma DB est créé automatiquement en environnement dev/test (commande/script documenté)
- [ ] docker compose up démarre Postgres + API et l’API fonctionne
- [ ] Tests OK (`pytest`)
- [ ] CI OK (workflow adapté si nécessaire)
- [ ] docs/DEV.md mise à jour

## Plan proposé (à remplir par l’agent)
1)
2)
3)

## Notes / décisions à prendre
- Choisir l’approche DB : (A) SQLAlchemy (simple) + création table au démarrage
  ou (B) psycopg + SQL brut + script init.
- Priorité : simplicité + reproductibilité.
