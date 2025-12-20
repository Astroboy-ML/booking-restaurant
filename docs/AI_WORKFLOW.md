# Workflow multi-agent — Restaurant Booking Platform

## Références projet obligatoires
- `docs/agents/` (fiches agents par spécialité).
- `docs/AI_WORKFLOW.md` (ce fichier).
- `docs/tasks/` (tickets : todo / in-progress / done).
- `Objectif_projet.md` (racine) alias `docs/PROJECT_CHARTER.md`.
- `docs/ARCHITECTURE.md` (vue d’ensemble + diagrammes).

> Workflow validé — mise à jour 2025-05-07.

## Lecture obligatoire avant toute action
1) Ticket ciblé.
2) `docs/AI_WORKFLOW.md`.
3) Fiche agent correspondant à l’area (`docs/agents/backend.md`, `frontend.md`, `devops.md`, `qa.md`, `security.md`, `product.md`).
4) `Objectif_projet.md` / `docs/PROJECT_CHARTER.md`.
5) `docs/ARCHITECTURE.md`.

## Conventions agents ↔ fichiers
- backend/api → `docs/agents/backend.md`
- frontend/web → `docs/agents/frontend.md`
- infra/devops/k8s/ci → `docs/agents/devops.md`
- qa/tests → `docs/agents/qa.md`
- sécurité → `docs/agents/security.md`
- produit/contenu/process → `docs/agents/product.md`

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

Règles de déplacement : uniquement `git mv docs/tasks/todo/<ticket>.md docs/tasks/in-progress/` (ou vers done) pour préserver l’historique.

## Discipline et sécurité
- Diff obligatoire avant tout commit (`git status` + `git diff`).
- Interdiction absolue de secrets (AWS keys/tokens, kubeconfig, .env réels, .tfstate, clés privées).
- Pas de nouvelles dépendances sans justification ticket.
- Tickets déplacés uniquement via `git mv`.
- Architecture mise à jour dès qu’un élément change (voir `docs/ARCHITECTURE.md`).
- Si Git ou le shell ne sont pas disponibles : produire un patch unifié complet (format `git diff`) pour toutes les modifications.

## Fallback sans Git/shell
- Rédiger un patch unifié complet couvrant toutes les modifications.
- Inclure les chemins des fichiers modifiés et le contenu exact du diff.
- Ajouter la liste des fichiers modifiés/ajoutés/supprimés + raison.

## Format obligatoire des tickets
- Basé sur `docs/tasks/_template.md` avec front-matter YAML (id, title, type, area, agents_required, depends_on, validated_by, validated_at) et sections normalisées (Contexte, Objectif, Hors scope, Scope technique, Contraintes, Deliverables, Critères d’acceptation, Comment tester, Plan, À contrôler).
- Alignement produit : si le ticket n’est pas cohérent avec `Objectif_projet.md`, l’agent product l’ajuste (modifs minimales) et documente les raisons dans le ticket.

## Ticket lifecycle (automatique)
Quand l’agent annonce "Finished working" / "Prêt à tester" ET que les corrections sont terminées, il DOIT :
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

### Règle : pas de demande d’autorisation
L’agent NE DOIT PAS demander “est-ce que je peux…”.
Il DOIT exécuter le plan et, s’il est bloqué (ex: DB inaccessible), fournir :
- le diagnostic
- les commandes exactes pour reproduire
- la correction proposée (diff)
- et l’état du ticket (bloqué / prêt à tester).

## Gestion des agents spécialisés
- Vérifier les fiches dans `docs/agents/` et créer l’agent manquant si requis par le ticket (backend, frontend, devops, qa, security, product).
- Utiliser la table de routage pour `agents_required` :
  - backend/api → backend, qa (selon criticité), security si auth/secrets.
  - frontend/web → frontend, qa.
  - infra/devops/k8s/ci → devops, security (si secrets/iam).
  - product/ux/contenu → product, frontend (si UI).
  - sécurité → security + agent concerné (backend/devops).
- Champ `agents_required` : liste explicite des agents devant intervenir selon l’area (ex: `[backend, qa]`).

## Hygiène documentaire
- Identifier les `.md` obsolètes ou redondants liés aux workflows. Actions possibles : fusionner dans `docs/AI_WORKFLOW.md`, déplacer vers `docs/archive/`, ou supprimer.
- Maintenir `docs/PROMPTS_AGENTS.md` aligné avec ce workflow (sinon le mettre à jour ou l’archiver).
- Noter toute décision d’archivage ou de maintien dans le rapport final.
- État au 2025-05-07 : aucune archive créée ; `docs/PROMPTS_AGENTS.md` conservé comme guide opérationnel.

## Scan anti-fuite (avant push)
- Scanner les fichiers tracked et untracked pour détecter : `AKIA|ASIA|SecretAccessKey|SessionToken|BEGIN RSA PRIVATE KEY|kubeconfig|.tfstate|.env`.
- Ne jamais afficher la valeur ; uniquement le chemin et le type de pattern détecté.
- En cas de détection : stopper, corriger, re-scanner.
