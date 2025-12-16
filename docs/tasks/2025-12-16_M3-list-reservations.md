# Ticket: M3 — List reservations (GET /reservations) from PostgreSQL

## But
Ajouter un endpoint de lecture qui liste les réservations persistées en PostgreSQL.

## Scope
- apps/api/
- docs/DEV.md (si commandes/notes changent)

## Contraintes
- Réutiliser la couche DB existante (SQL brut + psycopg + repository)
- Pas de refactor hors scope
- Pas de pagination/tri avancés en M3 (on garde simple)
- Tests obligatoires

## Spécification API
### GET /reservations
- Retourne 200
- Body : liste de réservations, chaque élément contient au minimum :
  - id, name, date_time, party_size

## Tests
- Ajouter au moins 1 test d’intégration DB :
  - créer 2 réservations (via repo ou via POST)
  - appeler GET /reservations
  - vérifier qu’au moins ces 2 réservations sont présentes

Optionnel : un test simple qui vérifie que GET renvoie une liste même vide (DB up mais table vide).

## Critères d’acceptation
- [ ] GET /reservations fonctionne et lit depuis PostgreSQL
- [ ] Tests unitaires OK
- [ ] Tests d’intégration DB OK (`pytest -m integration`)
- [ ] Docs à jour si nécessaire

## Plan proposé (à remplir par l’agent)
1)
2)
3)

## Notes
- Garder un SQL simple (SELECT … ORDER BY id ASC par exemple).