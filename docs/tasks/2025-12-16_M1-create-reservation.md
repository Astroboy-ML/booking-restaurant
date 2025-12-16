# Ticket: M1 — Create reservation (API + tests, in-memory)

## But
Ajouter la création d’une réservation côté API, avec validation des données et tests.

## Scope
- apps/api/ uniquement

## Contraintes
- Pas de DB (in-memory uniquement)
- Pas de refactor hors scope
- Pas de nouvelles dépendances non justifiées
- Ajouter des tests

## Spécification API
### POST /reservations
Body JSON :
- name: string (non vide)
- date_time: string (format ISO 8601 attendu)
- party_size: integer (> 0)

Réponse :
- 201 Created
- retourne une réservation avec un `id` (string ou int) + les champs du body

Erreurs :
- 422 sur validation (FastAPI/Pydantic)

## Critères d’acceptation
- [ ] Endpoint `POST /reservations` retourne 201 + un id
- [ ] Les données invalides renvoient 422 (test au moins un cas)
- [ ] Les tests passent (`pytest`)
- [ ] La doc est à jour si nécessaire (README API ou commentaire minimal)

## Plan proposé (à remplir par l’agent)
1)
2)
3)

## Notes
- Stockage en mémoire : une simple liste/dict dans le process suffit pour M1.
- La DB PostgreSQL sera ajoutée au ticket M2.
