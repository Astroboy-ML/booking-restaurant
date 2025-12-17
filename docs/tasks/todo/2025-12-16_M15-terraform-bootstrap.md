# Ticket: M15 — Terraform bootstrap (AWS provider + backend + lint)

## But
Initialiser la stack Terraform AWS pour préparer la phase cloud (ECR/EKS) sans créer encore de ressources coûteuses.

## Scope
- infra/terraform/
- Makefile (cibles tf-*)
- docs/DEV.md ou README Terraform

## Contraintes
- Aucun secret ou identifiant AWS en dur ; backend S3/remote paramétrable.
- Compatibilité `make tf-fmt`, `make tf-validate`, `make tf-plan` (plan sans apply par défaut).
- Version Terraform verrouillée et providers explicités.

## Deliverables
- Fichiers de base : providers/versions/backend/variables/outputs stubs.
- Cibles Makefile pour fmt/validate/plan avec instructions d’usage.
- Documentation Terraform (pré-requis AWS profile/OIDC, commandes).

## Critères d’acceptation
- [ ] `make tf-fmt` et `make tf-validate` passent sans ressources créées.
- [ ] Le backend et les variables sont documentés et non hardcodés.
- [ ] Pas de secret ou d’ARN collé en clair dans Git.

## Plan proposé
1) Créer les fichiers Terraform initiaux et verrouiller versions/providers.
2) Ajouter les cibles Makefile et tester fmt/validate/plan localement.
3) Documenter la configuration AWS/OIDC et l’exécution des commandes.
