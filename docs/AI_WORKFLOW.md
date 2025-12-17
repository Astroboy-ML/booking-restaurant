# Workflow multi-agent — Restaurant Booking Platform

## Statuts des tickets
- todo : besoin cadré mais non démarré par l’IA.
- in-progress : développement IA terminé, prêt à être testé/validé par l’humain (recette).
- done : validé par l’humain.

## Cycle
1) Idée / besoin identifié.
2) Débat expert (agents concernés) + proposition de solution.
3) Décision humaine (GO / priorisation).
4) Création ticket IA (`docs/tasks/todo/`) via le template.
5) Exécution IA (dev) sur une branche ou copie locale.
6) Quand prêt à tester : déplacer le ticket vers `docs/tasks/in-progress/` via `git mv`.
7) Validation humaine : tests/recette manuelle.
8) Si OK : `git mv` vers `docs/tasks/done/`. Sinon retour en todo avec commentaires.

Règle de déplacement : toujours utiliser `git mv docs/tasks/todo/<ticket>.md docs/tasks/in-progress/` (ou vers done) pour préserver l’historique.

## Format obligatoire des tickets
- Basé sur `docs/tasks/_template.md` avec front-matter YAML (id, title, type, area, agents_required, depends_on, validated_by, validated_at) et sections normalisées (Contexte, Objectif, Hors scope, Scope technique, Contraintes, Deliverables, Critères d’acceptation, Comment tester, Plan, À contrôler).

## Ticket lifecycle (automatique)

Quand l’agent annonce "Finished working" / "Prêt à tester" ET que :
Une fois que l'agent a terminé ses correction ALORS l’agent DOIT :
1) déplacer le ticket vers `docs/tasks/in-progress/` via git :
   - `git mv {TICKET_PATH} docs/tasks/in-progress/`
2) committer ce déplacement dans le même commit (ou un commit dédié) et inclure le chemin dans le résumé.

Sinon (tests non exécutés / incertitude), l’agent NE DOIT PAS déplacer le ticket et doit indiquer explicitement ce qu’il manque.
Tous les fichiers texte commités doivent être en UTF-8.
L’agent doit vérifier l’encodage du ticket (et des docs modifiées) avant commit.
Si du mojibake est détecté (ex: "dÇ¸faut", "rÇ¸servations"), l’agent doit corriger avant de pousser.

## Format obligatoire “À contrôler” (sortie IA)
- Liste des points à vérifier par l’humain (tests, captures éventuelles, scénarios manuels).
- Emplacement : section “À contrôler” du ticket, mise à jour par l’agent implémenteur.

## Table de routage (area → agents)
- backend/api → backend, qa (selon criticité), security si auth/secrets.
- frontend/web → frontend, qa.
- infra/devops/k8s/ci → devops, security (si secrets/iam).
- product/ux/contenu → product, frontend (si UI).
- sécurité → security + agent concerné (backend/devops).

Champ `agents_required` : liste explicite des agents devant intervenir selon l’area (ex: `[backend, qa]`).
