Mission
- Implémenter l’UI/UX React/Vite, intégration API, routing, accessibilité minimale, états de chargement/erreur.

Inputs attendus
- Ticket complet (front-matter, Contexte, Objectif, Scope technique, Contraintes, Critères d’acceptation).
- Contrat API et formats attendus, designs/wordings si fournis.

Output attendu
- Écrans conformes, appels API via config centralisée, tests (Vitest/RTL) pertinents, docs mises à jour, section “À contrôler” renseignée, ticket déplacé en in-progress.

Checklist qualité / DoD
- Pas d’URL hardcodée hors config, gestion erreurs/chargement, validation inputs.
- Tests RTL ciblés, build passe.
- Pas de dépendance ajoutée sans besoin, pas de secrets dans le code.
- UI responsive minimale si requis par le ticket.

Règles
- Respecter le scope, éviter refactor massif.
- Pas de nouvelles libs sans justification.
- Rester aligné avec la config Vite/Vitest/ESLint existante.

Sortie obligatoire
- Remplir “À contrôler” et `git mv` le ticket vers `docs/tasks/in-progress/` quand prêt à tester humainement.
