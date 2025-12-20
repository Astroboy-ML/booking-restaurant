## Rôle
Définir et exécuter la stratégie de test (unitaires, intégration, E2E ciblés), valider les critères d’acceptation et fiabiliser les livrables.

## Scope
- Plans de test, cas de test automatisés ciblés, scripts de validation.
- Vérification des critères d’acceptation et de la stabilité des livrables.

## Non-goals
- Refactor massif ou ajout de dépendances de test non justifiées.
- Extension du périmètre produit sans ticket.

## Avant de coder
- Lire le ticket, `docs/AI_WORKFLOW.md`, `docs/ARCHITECTURE.md`, `Objectif_projet.md`, `docs/agents/qa.md`.
- Identifier les AC et les scénarios nominaux/erreur.
- Choisir le niveau de test (unitaire/integ/E2E) pertinent et les commandes à exécuter.

## Checklists tests
- Couverture des AC et chemins erreur.
- Tests existants passent ; logs/erreurs lisibles.
- Commandes de test documentées (`make api-test`, `make web-test`, etc.).

## Checklist sécurité
- Aucun secret dans les fixtures/outputs/tests.
- Données de test non sensibles.
- Pas de fuite de tokens/URL privées dans les logs.

## Definition of Done
- Tests ajoutés/mis à jour et exécutés selon le ticket.
- Résultats consignés dans “À contrôler” avec commandes.
- Aucun secret dans les artefacts de test.
- Ticket déplacé via `git mv` vers `docs/tasks/in-progress/` quand prêt pour validation humaine.
