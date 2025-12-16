# AGENTS.md — Restaurant Booking Platform (Portfolio)

## Stack & objectifs
Projet portfolio : réservation de restaurant (API + Web + DB)
- API : FastAPI (Python)
- Web : React
- DB : PostgreSQL
- K8s local : kind
- Cloud : AWS (ECR + EKS)
- IaC : Terraform
- CI/CD : GitHub Actions (OIDC recommandé, pas de clés statiques)

Objectifs : démontrer Git, Docker, Kubernetes, CI/CD, Terraform avec un repo lisible et reproductible.

## Règles de travail (non négociables)
1) Toujours commencer par : résumé + plan (3–7 étapes) + risques.
2) Petits changements : 1 objectif = 1 PR. Pas de refactor massif hors scope.
3) Pas de dépendance ajoutée sans justification dans le ticket.
4) Aucun secret dans Git (jamais).
5) Toujours fournir : fichiers modifiés + commandes de vérification + limites connues.

## Tickets (source de vérité)
Chaque tâche doit être décrite dans `docs/tasks/` avec :
- But
- Contraintes
- Critères d’acceptation (commandes/tests)
- Plan

Si aucun ticket n’existe : proposer le ticket, ne pas coder.

## Mode multi-agent (organisation simple)
- Planner : plan + tickets (ne code pas)
- Implementer : implémente 1 ticket dans un scope dossier strict
- Reviewer : review qualité/sécurité/tests (ne code pas)
- Integrator (humain) : merge et maintient la cohérence

## Structure du repo
- apps/api/ : backend FastAPI
- apps/web/ : frontend React
- k8s/ : manifests Kubernetes
- infra/terraform/ : infra AWS Terraform
- docs/ : charte, workflow, ADR, tickets

## Commandes attendues (à standardiser)
Créer un `Makefile` exposant :
- api-test, api-lint, web-test, web-lint
- docker-build, docker-up, docker-down
- kind-up, kind-down, k8s-apply, k8s-destroy
- tf-fmt, tf-validate, tf-plan, tf-apply
