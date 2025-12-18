---
id: "2025-12-16_M18-eks-skeleton"
title: "M18 EKS skeleton"
type: feature
area: devops
agents_required: [devops]
depends_on: ["2025-12-16_M15-terraform-bootstrap", "2025-12-16_M17-ecr-build"]
validated_by:
validated_at:
---

## Contexte
Pas de cluster managé en place. Il faut préparer une ossature EKS (VPC, cluster, node group) pilotée par Terraform pour accueillir les déploiements (M19), sans créer le cluster en prod dans ce ticket.

## Objectif
Décrire l’infrastructure EKS minimale en Terraform avec variables configurables (réseau, sizing, endpoints) et documentation de plan (sans apply).

## Hors scope
- Déploiement des applications API/web (M19).
- Observabilité/addons avancés.
- Création effective des images (M17) et du cluster (apply).

## Scope technique
- Ressources Terraform pour VPC/subnets/IGW (NAT optionnel), IAM rôles EKS/nodegroup, cluster + node group paramétrables.
- Variables réseau/sizing/versions, configuration endpoint public/privé, logs, tags.
- Exemple tfvars documenté.

## Contraintes
- Dimensionnement modeste par défaut ; NAT désactivé par défaut pour éviter les coûts.
- Aucune fuite de secrets ou d’ARN sensibles ; rôles via assume-role/OIDC.
- Compatible avec `make tf-*` existants (init/validate/plan).

## Deliverables
- Fichiers Terraform EKS (VPC/IGW/NAT optionnel, IAM, cluster + node group).
- Exemple `examples/eks-dev.tfvars` sans secrets.
- Documentation des variables/prérequis et des commandes de plan (sans apply).

## Critères d’acceptation
- [ ] `terraform plan -var-file=<env>.tfvars` montre la création d’un cluster EKS + node group paramétrables sans erreurs.
- [ ] Variables réseau/sizing/roles documentées et modifiables sans changer le code.
- [ ] Aucun secret/ARN en clair ; identités référencées via variables/assume-role.

## Comment tester
1) `cd infra/terraform && terraform init -backend=false`.
2) Copier/adapter `examples/eks-dev.tfvars` (région, CIDR, AZs, subnets, sizing, endpoint).
3) `terraform plan -var-file=examples/eks-dev.tfvars` (ou votre tfvars). Nécessite des credentials AWS/assume-role.
4) Vérifier les outputs (cluster name/endpoint/OIDC issuer, VPC/subnets, rôle nodegroup).
5) Validation manuelle : s’assurer que l’accès OIDC et le verrouillage Terraform/backends configurés sont effectifs avant go/no-go (apply hors ticket).

## Plan
1) Définir VPC/subnets/IGW/NAT optionnel + rôles IAM EKS/nodegroup.
2) Décrire cluster EKS + node group paramétrables (version, sizing, endpoint, logs) + outputs utiles.
3) Ajouter tfvars d’exemple et doc (variables attendues, conventions de naming, commandes de plan, contrôle manuel OIDC/TF).

## À contrôler
- Résumé : VPC/subnets + EKS cluster + node group (Terraform), IAM rôles, tfvars exemple, doc mise à jour. NAT off par défaut, endpoint public configurable.
- Fichiers modifiés : `infra/terraform/{variables.tf,vpc.tf,iam.tf,eks.tf,outputs.tf,README.md}` ; `infra/terraform/examples/eks-dev.tfvars` ; ticket déplacé en in-progress.
- Commandes exécutées : aucune (pas de plan sans AWS creds). Prévu : `terraform -chdir=infra/terraform plan -var-file=examples/eks-dev.tfvars`.
- Checklist AC : plan attendu OK avec tfvars et creds ; variables réseau/sizing documentées ; pas de secrets/ARN en clair.
- Risques : échec plan sans credentials ; coûts si NAT activé ou sizing augmenté. Rollback : `git checkout -- infra/terraform docs/tasks/in-progress/2025-12-16_M18-eks-skeleton.md` puis remettre le ticket en todo si besoin.
