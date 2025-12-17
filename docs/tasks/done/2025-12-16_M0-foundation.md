# Ticket: M0 — Foundation (scaffold + workflow + hello API)

## But
Mettre en place les bases du repo pour travailler proprement (local + CI) avant de développer le produit.

## Contexte / fichiers
- apps/api/
- docker-compose.yml
- docs/DEV.md
- .github/ (CI à ajouter)
- (optionnel) Makefile / scripts

## Contraintes
- Pas de refactor inutile
- Pas de nouvelles dépendances non justifiées
- Pas de secrets dans Git
- Rester minimal et reproductible

## Critères d’acceptation
- [ ] API : endpoint `GET /health` retourne 200
- [ ] API : au moins 1 test automatisé pour `/health`
- [ ] Docker Compose : lance au minimum Postgres + API en local
- [ ] Documentation : `docs/DEV.md` indique comment lancer (compose) et tester
- [ ] CI : un workflow qui exécute au moins lint + tests API

## Plan proposé (à remplir par l’agent)
1)
2)
3)

## Notes / risques
- ...
