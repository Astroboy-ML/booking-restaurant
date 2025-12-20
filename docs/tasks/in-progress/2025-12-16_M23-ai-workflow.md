---
id: "M23"
title: "Adapter le workflow multi-agent et la documentation d'orchestration"
type: doc
area: product
agents_required:
  - product
  - devops
  - security
  - qa
depends_on: []
validated_by:
validated_at:
---

## Contexte
- Le workflow multi-agent doit être aligné avec les nouvelles contraintes de sécurité, de lecture obligatoire et de gestion des tickets.
- Les agents spécialisés doivent disposer de fiches complètes (rôle, scope, non-goals, checklists) et l’architecture doit rester compréhensible et illustrée.
- Des règles de discipline (diff avant commit, git mv pour les tickets) et de fallback (patch unifié si Git/shell indisponible) sont imposées.

## Objectif
- Mettre à jour `docs/AI_WORKFLOW.md` et les fiches agents pour refléter les nouvelles règles de collaboration multi-agent, de sécurité, et de traçabilité.
- Tenir `docs/ARCHITECTURE.md` à jour avec des diagrammes lisibles (high-level + runtime) et pointer clairement vers les références projet.
- Garantir qu’aucun document obsolète ne perturbe le workflow (archiver ou fusionner si nécessaire).

## Hors scope
- Ajout de nouvelles fonctionnalités produit (API/web) ou de nouvelles dépendances logicielles.
- Modification du code applicatif (backend/front) hors documentation et tickets.
- Refonte majeure du process CI/CD ou de Terraform.

## Scope technique
- Documents concernés : `docs/AI_WORKFLOW.md`, `docs/agents/*.md`, `docs/ARCHITECTURE.md`, `docs/PROMPTS_AGENTS.md` (vérification de redondance), fichiers de référence projet (Objectif_projet/`PROJECT_CHARTER.md`).
- Ticket et sections « À contrôler » mis à jour le cas échéant.

## Contraintes
- Aucune fuite de secret ou artefact sensible (AWS keys, kubeconfig, .env, .tfstate, tokens).
- Pas d’ajout de dépendance.
- Respect strict du format des tickets et des règles de déplacement (`git mv`) si changement de statut.

## Deliverables
- `docs/AI_WORKFLOW.md` enrichi (références obligatoires, lecture préalable, mapping agents↔fichiers, fallback patch, discipline diff/commit).
- Fiches agents complètes (rôle, scope, non-goals, checklists avant de coder, tests, sécurité, Definition of Done).
- `docs/ARCHITECTURE.md` avec diagrammes Mermaid high-level et runtime flow lisibles par un non-expert.
- Décision documentée sur les docs obsolètes/redondantes (fusion/archivage/suppression).
- Section « À contrôler » mise à jour avec commandes/tests et points de validation.

## Critères d’acceptation
- Les règles de lecture obligatoire (ticket + workflow + fiche agent + Objectif_projet + ARCHITECTURE) sont clairement énoncées et visibles.
- Le mapping agents↔fichiers est explicite (docs/agents/backend.md, frontend.md, devops.md, qa.md, security.md, product.md).
- Le fallback patch complet (git diff unifié) est documenté pour absence Git/shell.
- Discipline rappelée : diff obligatoire avant commit, déplacements de tickets uniquement via `git mv`.
- Architecture contient au moins deux diagrammes Mermaid (high-level components, runtime flow) et reste compréhensible par un non expert.
- Les fiches agents intègrent rôle, scope, non-goals, checklists « avant de coder », checklists tests, checklists sécurité, Definition of Done.
- Aucun secret/artefact interdit n’est présent dans le dépôt (scan réalisé).

## Comment tester
- Relire `docs/AI_WORKFLOW.md`, vérifier la présence des nouvelles sections/règles listées en Critères d’acceptation.
- Vérifier chaque fiche agent (`docs/agents/*.md`) pour la structure attendue et les checklists.
- Relire `docs/ARCHITECTURE.md` et valider la lisibilité des deux diagrammes Mermaid.
- Exécuter un scan anti-fuite (fichiers tracked + untracked) pour détecter `AKIA|ASIA|SecretAccessKey|SessionToken|.tfstate|.env|kubeconfig|BEGIN RSA PRIVATE KEY` (sans afficher de secrets).

## Plan
1) Lire `docs/AI_WORKFLOW.md`, `docs/PROJECT_CHARTER.md` (Objectif_projet), `docs/ARCHITECTURE.md` et ce ticket.
2) Mettre à jour `docs/AI_WORKFLOW.md` avec les règles obligatoires (références, lecture, mapping agents, fallback patch, discipline diff/commit).
3) Compléter les fiches agents (`docs/agents/*.md`) avec rôle, scope, non-goals, checklists avant de coder/tests/sécurité, Definition of Done.
4) Mettre à jour `docs/ARCHITECTURE.md` avec diagrammes Mermaid high-level et runtime, texte simplifié.
5) Vérifier les documents potentiellement obsolètes/redondants et décider (fusion/archivage); exécuter le scan anti-fuite puis préparer le rapport et le déplacement du ticket si prêt.

## À contrôler
- Résumé des changements : AI_WORKFLOW enrichi (références, lectures obligatoires, fallback, discipline, hygiène doc), fiches agents restructurées (rôle/scope/non-goals/checklists/DoD), ARCHITECTURE complétée (diagrammes high-level + runtime), ajout de `Objectif_projet.md`, aucun doc obsolète à archiver (PROMPTS_AGENTS conservé).
- Commandes exécutées : `rg --hidden --no-ignore --files-with-matches -g'*' -e '(AKIA|ASIA)[0-9A-Z]{16}|SecretAccessKey|SessionToken|BEGIN RSA PRIVATE KEY|kubeconfig|\\.tfstate|\\.env'` (aucun secret, seulement des mentions de patterns/doc/node_modules).
- Vérification des critères d’acceptation : sections présentes (références, lecture obligatoire, mapping agents, fallback patch, discipline diff/git mv), fiches agents complètes, architecture avec 2 diagrammes Mermaid lisibles.
- Points de validation humaine : relire les sections ajoutées dans `docs/AI_WORKFLOW.md`, contrôler un rendu Mermaid, vérifier lisibilité pour non-experts, confirmer que `docs/PROMPTS_AGENTS.md` reste utile.
- Risques/limitations : pas de tests automatisés (documents uniquement), nombreux faux positifs attendus au scan (node_modules, mentions de patterns).
- Rollback : `git checkout -- <fichiers>` ou revert du commit associé.
