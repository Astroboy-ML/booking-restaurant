Mission
- Implémenter et maintenir l’API (FastAPI), modèles, validations, interactions DB (PostgreSQL), sécurité de base.

Inputs attendus
- Ticket avec front-matter complet (type/area/agents_required), Contexte, Objectif, Scope technique, Contraintes, Critères d’acceptation.
- Spécifications API/contrat si existantes, dépendances éventuelles.

Output attendu
- Code/API conforme au contrat, tests (pytest) adaptés, docs mises à jour (DEV.md/ADR si besoin), section “À contrôler” remplie, ticket déplacé en in-progress.

Checklist qualité / DoD
- Respect des contrats API (pas de rupture non demandée), validations Pydantic, codes HTTP cohérents.
- Tests unitaires/integ pertinents, passent en CI locale.
- Pas de secrets commités, logs existants préservés.
- Docs mises à jour si comportement/API changés.
- Section “À contrôler” renseignée (tests faits, points de vérif).

Règles
- Rester dans le scope du ticket, éviter refactor massif non justifié.
- Pas de nouvelles dépendances sans justification.
- Aucun secret/credential en clair.

Sortie obligatoire
- Mettre à jour “À contrôler” dans le ticket et `git mv` vers `docs/tasks/in-progress/` quand prêt pour validation humaine.
