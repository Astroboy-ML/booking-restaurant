# Ticket: M4 — Cancel reservation (DELETE /reservations/{id})

## But
Ajouter la suppression (annulation) d’une réservation persistée en PostgreSQL.

## Scope
- apps/api/
- docs/DEV.md (si besoin)

## Contraintes
- Réutiliser la couche repository SQL brut existante
- Pas de refactor hors scope
- Tests obligatoires (unit + integration si possible)
- Réponse claire en cas d’id inexistant

## Spécification API
### DELETE /reservations/{id}
- Si la réservation existe : supprimer en DB et retourner 204 No Content (ou 200 avec payload, mais choisir 204 de préférence)
- Si l’id n’existe pas : retourner 404 Not Found

## Tests
- Test d’intégration DB :
  1) créer une réservation via POST
  2) la supprimer via DELETE
  3) appeler GET /reservations et vérifier qu’elle n’est plus présente
- Test “not found” :
  - DELETE sur un id inexistant → 404
- Les tests DB doivent être marqués `integration` et skippables si DB down

## Critères d’acceptation
- [ ] DELETE /reservations/{id} supprime réellement en PostgreSQL
- [ ] 204 quand supprimé, 404 si inexistant
- [ ] Tests OK (`pytest`)
- [ ] Tests integration OK (`pytest -m integration`)
- [ ] Docs à jour si nécessaire

## Plan proposé (à remplir par l’agent)
1)
2)
3)
