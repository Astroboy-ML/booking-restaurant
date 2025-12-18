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
Le dossier `infra/terraform` est vide : il faut initialiser la stack Terraform AWS pour préparer les travaux ECR/EKS sans créer de ressources coûteuses pour l’instant.

## Objectif
Disposer d’une base Terraform prête à l’emploi (providers, backend, verrous de versions) avec des commandes Makefile documentées pour fmt/validate/plan.

## Hors scope
- Création des ressources ECR/EKS (gérées par d’autres tickets).
- Ajout de secrets ou d’identifiants AWS en clair dans le dépôt.
- Exécution d’un `terraform apply` sur une infrastructure de production.

## Scope technique
- Fichiers initiaux Terraform (`versions.tf`, providers, backend paramétrable, variables/outputs stubs) dans `infra/terraform`.
- Cibles Makefile `tf-fmt`, `tf-validate`, `tf-plan` alignées sur les fichiers Terraform.
- Documentation d’usage (pré-requis AWS/OIDC, commandes) dans `infra/terraform/README.md` ou `docs/DEV.md`.

## Contraintes
- Aucun secret ou ARN en dur ; backend et credentials passés par variables/ENV.
- Compatibilité `terraform init -backend=false` pour fmt/validate sans backend distant.
- Versions Terraform et providers verrouillées pour éviter les dérives.

## Deliverables
- Fichiers Terraform de base avec backend configurable et verrous de versions.
- Nouvelles cibles Makefile pour fmt/validate/plan.
- Documentation décrivant la configuration AWS/OIDC et les commandes à exécuter.

## Critères d’acceptation
- [ ] `terraform fmt -check` et `terraform validate` passent dans `infra/terraform` après un `terraform init -backend=false`.
- [ ] Les cibles `make tf-fmt`, `make tf-validate` et `make tf-plan` fonctionnent sans secrets codés en dur (variables/env documentés).
- [ ] La documentation explique le backend et les variables (aucun nom de bucket/ARN figé dans Git).

## Comment tester
1) `cd infra/terraform`
2) `terraform init -backend=false`
3) `terraform fmt -check`
4) `terraform validate`
5) Revenir à la racine et lancer `make tf-fmt` puis `make tf-validate` (après ajout des cibles).
6) Simuler un plan : `make tf-plan TF_VAR_backend_bucket="<bucket>" TF_VAR_backend_region="<region>" -e TF_CLI_ARGS_plan="-out=plan.tfplan"` (ne pas appliquer).

## Plan
1) Ajouter les fichiers Terraform initiaux (versions/providers/backend/variables/outputs) avec valeurs par défaut neutres.
2) Créer les cibles Makefile tf-fmt/tf-validate/tf-plan en pointant vers `infra/terraform`.
3) Documenter les prérequis AWS/OIDC et le mode d’exécution (init -backend=false, fmt, validate, plan).

## À contrôler
- Vérifier l’absence de secrets/ARN en clair dans les fichiers Terraform ou le Makefile.
- Confirmer que le plan reste sans effet par défaut (pas d’apply automatique).
- S’assurer que le backend distant est paramétrable et non imposé.
