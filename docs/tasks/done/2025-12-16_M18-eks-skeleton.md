---
id: "2025-12-16_M18-eks-skeleton"
title: "M18 EKS skeleton"
type: feature
area: devops
agents_required: [devops]
depends_on: ["2025-12-16_M15-terraform-bootstrap", "2025-12-16_M17-ecr-build"]
validated_by: codex
validated_at: 2025-12-20
---

## Contexte
Pas de cluster manage en place. Il faut preparer une ossature EKS (VPC, cluster, node group) pilotee par Terraform pour accueillir les deploiements (M19), sans creer le cluster en prod dans ce ticket.

## Objectif
Decrire l infrastructure EKS minimale en Terraform avec variables configurables (reseau, sizing, endpoints) et documentation de plan (sans apply).

## Hors scope
- Deploiement des applications API/web (M19).
- Observabilite/addons avances.
- Creation effective des images (M17) et du cluster (apply).

## Scope technique
- Ressources Terraform pour VPC/subnets/IGW (NAT optionnel), IAM roles EKS/nodegroup, cluster + node group parametrables.
- Variables reseau/sizing/versions, configuration endpoint public/prive, logs, tags.
- Exemple tfvars documente.

## Contraintes
- Dimensionnement modeste par defaut ; NAT desactive par defaut pour eviter les couts.
- Aucune fuite de secrets ou d ARN sensibles ; roles via assume-role/OIDC.
- Compatible avec `make tf-*` existants (init/validate/plan).

## Deliverables
- Fichiers Terraform EKS (VPC/IGW/NAT optionnel, IAM, cluster + node group).
- Exemple `examples/eks-dev.tfvars` sans secrets.
- Documentation des variables/prerequis et des commandes de plan (sans apply).

## Criteres d acceptation
- [x] `terraform plan -var-file=<env>.tfvars` montre la creation d un cluster EKS + node group parametrables sans erreurs.
- [x] Variables reseau/sizing/roles documentees et modifiables sans changer le code.
- [x] Aucun secret/ARN en clair ; identites referencees via variables/assume-role.

## Comment tester
1) Exporter les creds en PowerShell : `$env:AWS_PROFILE="booking-dev"; $env:AWS_REGION="eu-west-3"; $env:AWS_DEFAULT_REGION="eu-west-3"; aws sts get-caller-identity`.
2) `terraform -chdir=infra/terraform init -backend=false -reconfigure`.
3) `terraform -chdir=infra/terraform fmt -recursive` puis `terraform -chdir=infra/terraform validate`.
4) `terraform -chdir=infra/terraform plan -var-file=examples/eks-dev.tfvars` (profil booking-dev). Plan attendu : VPC 10.10.0.0/16, subnets publics/prives sur 3 AZ, cluster EKS 1.30 `booking-eks-dev`, nodegroup `booking-ng-dev` t3.small (2/1/3), roles IAM cluster/node + policies EKS/CNI/ECR.
5) Validation manuelle : verifier outputs (cluster name/endpoint/OIDC issuer, VPC/subnets, role nodegroup) et que le backend distant reste optionnel (pas d apply).

## Plan
1) Definir VPC/subnets/IGW/NAT optionnel + roles IAM EKS/nodegroup.
2) Decrire cluster EKS + node group parametrables (version, sizing, endpoint, logs) + outputs utiles.
3) Ajouter tfvars d exemple et doc (variables attendues, conventions de naming, commandes de plan, controle manuel OIDC/TF).

## A controler
- Resume : plan Terraform reussi avec profil local `booking-dev` (init fmt validate plan). VPC/subnets + cluster EKS 1.30 + node group t3.small 2/1/3, endpoints public+prive, NAT off par defaut.
- Fichiers modifies : `infra/terraform/README.md` (profil local), `Makefile` (profil/region par defaut pour tf-validate/tf-plan), formatage `infra/terraform/vpc.tf`. Pas de secrets ajoutes.
- Commandes executees : `terraform -chdir=infra/terraform init -backend=false -reconfigure`, `fmt -recursive`, `validate`, `plan -var-file=examples/eks-dev.tfvars` avec env `AWS_PROFILE/REGION=booking-dev/eu-west-3`.
- Checklist AC : plan OK avec tfvars d exemple ; variables reseau/sizing documentees et modifiables ; aucun secret/ARN en clair (profil local uniquement).
- Risques : couts si NAT active ou sizing augmente ; backend distant a configurer s il est requis en prod. Rollback : `git checkout -- infra/terraform docs/tasks/*/2025-12-16_M18-eks-skeleton.md` puis replanifier.
