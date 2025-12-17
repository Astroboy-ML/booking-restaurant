# Ticket: M13 — Validation et contrats API renforcés

## But
Durcir la validation et clarifier les schémas de l’API de réservation **sans changer le périmètre MVP** (mêmes routes, mêmes champs), tout en rendant les erreurs **prévisibles, explicites et testées**.

## Scope
- `apps/api/` (schemas Pydantic, routes/handlers, error handling)
- Tests API (`pytest`)
- `docs/DEV.md` (erreurs standards + exemples)

## Contraintes
- **Conserver les routes existantes** (ex: `GET /reservations`, `POST /reservations`, `DELETE /reservations/{id}` si déjà présent).
- **Conserver les champs existants** : `name`, `date_time`, `party_size` (pas de renommage).
- Pas de refactor massif : modifications ciblées (schemas + validations + gestion d’erreur + tests).
- Logs existants préservés (ne pas supprimer les logs, ne pas réduire l’observabilité).
- Ne pas casser le front : les réponses d’erreur doivent rester lisibles côté UI.

## Décisions attendues (pour éviter ambiguïtés)
- Statut HTTP :
  - Validation automatique FastAPI/Pydantic : **422** (par défaut).
  - Validations métier explicites (ex: date passée) : **422 ou 400**, mais **choisir un seul standard** et l’appliquer partout.
- `date_time` :
  - Doit être **parseable** (format ISO 8601 recommandé) et **dans le futur**.
  - Documenter clairement le format accepté et des exemples.

## Deliverables
1) **Schémas Pydantic séparés request/response**
- `ReservationCreateRequest` (POST) avec validations :
  - `name`: non vide (`strip` + longueur > 0)
  - `party_size`: int > 0
  - `date_time`: non vide + parseable + date future
- `ReservationResponse` (GET/POST response) : conserver les champs existants, inclure `id` si déjà renvoyé aujourd’hui.

2) **Gestion d’erreurs cohérente et documentée**
- Standardiser un payload d’erreur **unique** pour :
  - erreurs de validation
  - erreurs applicatives (ex: 404 si suppression d’une réservation inexistante, si applicable)
- Exemple de structure attendue (à adapter, mais unique et documentée) :
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request",
    "fields": [
      { "field": "party_size", "message": "must be > 0" },
      { "field": "date_time", "message": "must be a future datetime" }
    ]
  }
}

## Plan proposé (à remplir par l’agent)
1)
2)
3)