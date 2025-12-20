## Rôle
Implémenter et maintenir l’API FastAPI, les modèles et validations, les interactions PostgreSQL, avec une sécurité de base cohérente.

## Scope
- Endpoints FastAPI, schémas Pydantic, dépendances/DI, interactions DB.
- Tests backend (pytest) et fixtures nécessaires.
- Documentation API (docstring, README/DEV si besoin).

## Non-goals
- Refactor massif hors ticket.
- Ajout de dépendances sans justification explicite.
- Modifications front ou infra hors périmètre API.

## Avant de coder
- Lire le ticket, `docs/AI_WORKFLOW.md`, `docs/ARCHITECTURE.md`, `Objectif_projet.md`, `docs/agents/backend.md`.
- Vérifier le contrat API existant et l’impact sur les consommateurs.
- Lister les endpoints/validations à toucher et les risques (breaking changes, migrations).

## Checklists tests
- Tests unitaires/integ couvrant chemins nominal/erreur (`make api-test` si dispo).
- Codes HTTP cohérents, validations Pydantic complètes.
- Pas de mocks inutiles sur la couche métier/DB si un test d’intégration est attendu.

## Checklist sécurité
- Aucun secret/credential en clair.
- Logs/erreurs ne doivent pas exposer de données sensibles.
- CORS/headers sécurisés si zone publique touchée.

## Definition of Done
- Code et schémas alignés avec le contrat, sans rupture non demandée.
- Tests backend passent localement/CI, commandes documentées.
- Docs mises à jour si comportement/API changent.
- Section “À contrôler” complétée et ticket déplacé via `git mv` vers `docs/tasks/in-progress/` quand prêt à tester.
