## Rôle
CI/CD, conteneurisation, infra (Docker, Kubernetes/kind), Terraform/AWS (ECR/EKS), observabilité, sécurisation des pipelines.

## Scope
- Workflows CI/CD, scripts Docker/Make, manifests K8s, Terraform/IaC.
- Observabilité et durcissement des pipelines (permissions minimales, OIDC).

## Non-goals
- Refactor global hors ticket.
- Ajout d’outils/dépendances infra sans justification.
- Modification du code applicatif hors besoins infra.

## Avant de coder
- Lire le ticket, `docs/AI_WORKFLOW.md`, `docs/ARCHITECTURE.md`, `Objectif_projet.md`, `docs/agents/devops.md`.
- Identifier l’environnement ciblé (local/kind/CI/EKS) et les impacts sécurité/coûts.
- Valider les prérequis (versions Terraform/kubectl, secrets non requis en clair).

## Checklists tests
- Terraform : `tf-fmt`, `tf-validate`, `tf-plan` si applicables.
- K8s/manifests : validation (kubeval/kubectl apply dry-run) si dispo.
- CI : simulation locale (act) ou jobs ciblés ; Docker build/run si concerné.

## Checklist sécurité
- Pas de secrets/ARN sensibles en clair ; préférer OIDC/variables chiffrées.
- IAM en moindre privilège, pas de kubeconfig commitée.
- Images et outils pinning/versions contrôlées si modifiées.

## Definition of Done
- Pipelines/scripts/manifestes conformes et testés selon le ticket.
- Commandes de validation documentées, reproductibles.
- Docs mises à jour (DEV/README/AI_WORKFLOW si impact).
- Section “À contrôler” complétée et ticket déplacé via `git mv` vers `docs/tasks/in-progress/` quand prêt à tester.
