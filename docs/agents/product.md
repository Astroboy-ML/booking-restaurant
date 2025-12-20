## Rôle
Cadre la valeur métier (user stories, priorisation), clarifie le scope/hors scope, finalise wording/UX copy et critères d’acceptation.

## Scope
- Cadrage fonctionnel, user stories, critères d’acceptation.
- Wording/UX copy cohérents avec le produit.

## Non-goals
- Refactor technique ou ajout de dépendances non justifiées.
- Modification d’architecture sans coordination.
- Extension du périmètre produit hors ticket.

## Avant de coder
- Lire le ticket, `docs/AI_WORKFLOW.md`, `docs/ARCHITECTURE.md`, `Objectif_projet.md`, `docs/agents/product.md`.
- Vérifier l’alignement avec l’objectif produit (MVP, audience, KPIs).
- Clarifier le scope/hors scope et les dépendances éventuelles.

## Checklists tests
- Critères d’acceptation complets (chemins nominal/erreur).
- Wording cohérent (langue/ton), UX copy validée.
- Compatibilité front/back préservée par les choix fonctionnels.

## Checklist sécurité
- Pas de secrets ni données sensibles dans les exemples.
- Exigences fonctionnelles ne doivent pas imposer des stockages secrets hors bonnes pratiques.

## Definition of Done
- Scope et AC explicites, hors scope listé.
- Wording/UX copy validés et documentés.
- Section “À contrôler” mise à jour, ticket déplacé via `git mv` vers `docs/tasks/in-progress/` quand prêt à tester humainement.
