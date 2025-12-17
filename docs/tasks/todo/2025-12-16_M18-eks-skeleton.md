# Ticket: M18 — Squelette EKS (VPC + cluster + node group minimal)

## But
Définir l’infrastructure minimale EKS pour préparer un déploiement cloud après stabilisation du MVP.

## Scope
- infra/terraform/ (modules VPC/EKS)
- docs/DEV.md ou README infra

## Contraintes
- Utiliser des modules maintenus (VPC + EKS) ; dimensionnement minimal pour une démo.
- Pas de workloads applicatifs déployés dans ce ticket.
- Variables pour tailles/nœuds configurables ; pas de credentials hardcodés.

## Deliverables
- Terraform pour VPC, subnets, cluster EKS et un node group léger (scalable).
- Outputs nécessaires pour kubeconfig (cluster name/ARN, région, endpoint).
- Documentation plan/apply (avec avertissement coûts) et récupération de kubeconfig.

## Critères d’acceptation
- [ ] `terraform plan` crée seulement VPC + EKS + node group minimal.
- [ ] kubeconfig récupérable via outputs/commande documentée.
- [ ] Aucun secret ou identifiant en clair dans le code.

## Plan proposé
1) Importer/configurer les modules VPC et EKS avec variables pour tailles/subnets.
2) Ajouter outputs utiles (kubeconfig, cluster ARN, node group) et tags.
3) Documenter les étapes plan/apply et les précautions coûts.
