# Ticket: M13 — Validation et contrats API renforcés

## But
Durcir la validation et clarifier les schémas de l’API de réservation sans changer le périmètre MVP.

## Scope
- apps/api/ (schemas, routes)
- tests API
- docs/DEV.md (erreurs standards)

## Contraintes
- Conserver les champs actuels (name, date_time, party_size) et les routes.
- Messages d’erreur explicites pour les cas invalides ; pas de refactor massif.
- Logs existants préservés.

## Deliverables
- Schémas Pydantic séparés request/response avec validations (date future, party_size > 0, name non vide).
- Gestion d’erreurs cohérente (HTTPException structurée) et payload d’erreur documenté.
- Tests couvrant cas invalides (date passée, taille <=0, nom vide) + cas succès.

## Critères d’acceptation
- [ ] Les requêtes invalides retournent 400/422 avec message clair.
- [ ] Les tests API passent (pytest).
- [ ] Docs indiquent les erreurs typiques et formats de réponse.

## Plan proposé
1) Centraliser/raffiner les schémas Pydantic et validations.
2) Ajuster les handlers pour renvoyer des erreurs structurées.
3) Étendre les tests et mettre à jour la documentation des erreurs.
