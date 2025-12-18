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
Aucun cluster Kubernetes managé n’est encore défini. Il faut préparer une ossature EKS (cluster + nodegroups) pilotée par Terraform pour accueillir les déploiements ultérieurs.

## Objectif
Décrire l’infrastructure EKS minimale (réseau, cluster, nodegroups) en Terraform avec variables configurables, sans lancer d’`apply` par défaut.

## Hors scope
- Déploiement des applications API/web (traité par M19).
- Mise en place d’observabilité (M20) ou d’addons avancés (ServiceMesh, ExternalDNS, etc.).
- Création effective des images (couvert par M17).

## Scope technique
- Modules/ressources Terraform pour VPC/subnets/roles nécessaires au cluster EKS minimal.
- Variables pour le sizing (instances, nodes min/max), région, VPC/subnets, et configuration kubeconfig.
- Documentation des commandes `terraform plan` (sans apply) et des paramètres attendus.

## Contraintes
- Dimensionnement modeste pour limiter les coûts ; possibilité de désactiver certaines ressources via variables.
- Pas de secrets ou d’ARN en clair dans le code ; utiliser des variables pour les rôles/identités.
- Compatibilité avec les cibles Makefile tf-* définies en bootstrap.

## Deliverables
- Fichiers Terraform décrivant VPC/subnets (si absents), cluster EKS et nodegroups configurables.
- Exemple de fichier `*.tfvars` documenté (non secret) pour un plan de test.
- Documentation des commandes de plan/apply (apply optionnel) et des prérequis IAM.

## Critères d’acceptation
- [ ] `terraform plan -var-file=<env>.tfvars` affiche la création d’un cluster EKS + nodegroups paramétrables sans erreurs.
- [ ] Les variables réseau/sizing/roles sont documentées et modifiables sans changer le code.
- [ ] Aucun secret/ARN en clair ; les identités sont référencées via variables ou data sources.

## Comment tester
1) `cd infra/terraform`
2) `terraform init -backend=false`
3) Préparer un `dev.tfvars` d’exemple (bucket/région/VPC/subnets/nodegroups) sans secrets.
4) `terraform plan -var-file=dev.tfvars` (ne pas appliquer) et vérifier le rendu du cluster/nodegroups.
5) Optionnel : `make tf-plan TF_VAR_file=dev.tfvars` si une cible dédiée est ajoutée.

## Plan
1) Définir les ressources réseau/roles nécessaires (VPC/subnets/roles EKS) avec variables associées.
2) Décrire le cluster EKS et les nodegroups avec sizing paramétrable ; générer outputs utiles (kubeconfig, ARNs).
3) Documenter l’exécution de `terraform plan` (sans apply) et les paramètres attendus (tfvars exemples).

## À contrôler
- Impact coûts (types/nombre de nœuds) clairement indiqué dans la doc.
- Validation que le plan ne dépend pas de secrets locaux.
- Cohérence avec le dépôt ECR et les régions choisies.
