## Rôle
Implémenter l’UI/UX React (Vite), intégrer l’API, gérer routing, accessibilité minimale et états de chargement/erreur.

## Scope
- Composants React, hooks et store local.
- Intégration API via config centralisée, gestion erreurs/loading.
- Styles/responsivité légers selon ticket.

## Non-goals
- Refactor massif de la stack/front.
- Ajout de bibliothèques sans justification ticket.
- Changement de contrats API sans coordination backend/product.

## Avant de coder
- Lire le ticket, `docs/AI_WORKFLOW.md`, `docs/ARCHITECTURE.md`, `Objectif_projet.md`, `docs/agents/frontend.md`.
- Vérifier les contrats API utilisés et l’impact UX (loading/error states).
- Identifier les composants concernés et les risques UX (accessibilité, mobile).

## Checklists tests
- Tests Vitest/RTL sur chemins nominal/erreur (`make web-test` si dispo).
- Build/lint front passent (`make web-lint`).
- Props et validations cohérentes, snapshots si pertinent.

## Checklist sécurité
- Aucune URL/API hardcodée hors config.
- Pas de secrets/clefs dans le code ou les exemples.
- Erreurs affichées sans fuite d’infos sensibles.

## Definition of Done
- UI conforme, intégration API fonctionnelle avec états d’erreur/chargement.
- Tests front passent, commandes documentées.
- Docs/wording mis à jour si changé.
- Section “À contrôler” complétée et ticket déplacé via `git mv` vers `docs/tasks/in-progress/` quand prêt à tester.
