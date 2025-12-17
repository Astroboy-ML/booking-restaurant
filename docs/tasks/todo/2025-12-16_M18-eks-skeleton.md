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

# Ticket: M18 EKS skeleton

## But
Mettre en place l’ossature EKS (cluster, nodegroups) sans déployer encore l’application complète.

## Scope
- Terraform EKS (infra/terraform)
- Paramétrage réseau de base (VPC/subnets) si non existant
- Documentation

## Contraintes
- Pas de ressources coûteuses non maîtrisées (tailles modestes, éventuellement désactivées en plan-only)
- Variables pour VPC/subnets et sizing
- Pas de secrets en clair

## Deliverables
- Modules/ressources Terraform pour créer un cluster EKS minimal
- Variables documentées
- Cibles Makefile ou commandes pour plan/apply (plan-only par défaut)

## Critères d’acceptation
- [ ] Le plan Terraform affiche la création d’un cluster EKS et nodegroups configurables
- [ ] Les variables réseau/sizing sont paramétrables et documentées
- [ ] Pas de secret ou ARN en clair dans Git

## Plan proposé
1) Définir VPC/subnets/roles nécessaires (variables)
2) Décrire le cluster EKS (nodegroups) en Terraform
3) Documenter les commandes de plan/apply et les paramètres
