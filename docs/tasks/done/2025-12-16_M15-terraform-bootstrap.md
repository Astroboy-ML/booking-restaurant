---
id: "2025-12-16_M15-terraform-bootstrap"
title: "M15 Terraform bootstrap (AWS provider + backend + lint)"
type: feature
area: devops
agents_required: [devops]
depends_on: []
validated_by:
validated_at:
---

## Contexte
Le dossier `infra/terraform` était vide : il fallait initialiser la stack Terraform AWS pour préparer les travaux ECR/EKS sans créer de ressources coûteuses pour l’instant.

## Réalisé
- Ajout d’une base Terraform (versions, provider AWS, backend S3 paramétrable, variables/outputs) compatible avec `terraform init -backend=false`.
- Nouvelles cibles Makefile `tf-fmt`, `tf-validate` et `tf-plan` pointant vers `infra/terraform` avec configuration du backend par variables d’environnement.
- Documentation `infra/terraform/README.md` détaillant prérequis OIDC/ENV, backend configurables et commandes à exécuter.

## Critères d’acceptation
- [x] `terraform fmt -check` et `terraform validate` passent dans `infra/terraform` après un `terraform init -backend=false`.
- [x] Les cibles `make tf-fmt`, `make tf-validate` et `make tf-plan` fonctionnent sans secrets codés en dur (variables/env documentés).
- [x] La documentation explique le backend et les variables (aucun nom de bucket/ARN figé dans Git).

## Comment tester
1) `cd infra/terraform`
2) `terraform init -backend=false`
3) `terraform fmt -check`
4) `terraform validate`
5) Revenir à la racine et lancer `make tf-fmt` puis `make tf-validate`.
6) Simuler un plan :
   ```bash
   TF_BACKEND_BUCKET="<bucket>" \
   TF_BACKEND_REGION="<region>" \
   TF_BACKEND_DYNAMODB_TABLE="<optional-lock-table>" \
   make tf-plan TF_PLAN_ARGS="-out=plan.tfplan"
   ```

## À contrôler
- Absence de secrets/ARN en clair dans les fichiers Terraform ou le Makefile.
- Le plan reste sans effet par défaut (aucun `apply`).
- Le backend distant est paramétrable et non imposé.
