# Project Charter — Restaurant Booking Platform

## Objectif
Construire une mini-plateforme de réservation de restaurant (API + Web + DB) pour démontrer :
- Git (PR, conventions, historique propre)
- Docker (images reproductibles)
- Kubernetes (déploiement local puis cloud)
- CI/CD (tests, build, déploiement)
- Terraform (infra AWS as code)

## Portée (scope)
Produit : gestion simple de réservations.
Public cible : démo portfolio (pas une prod réelle).

## MVP (3 fonctionnalités)
1) Créer une réservation
   - champs minimum : name, date_time, party_size (nb de personnes)
2) Lister les réservations
3) Annuler une réservation (par id)

## Hors-scope (au début)
- Authentification/autorisation
- Paiement
- Notifications email/SMS
- Gestion avancée de tables/plan de salle
- Multi-restaurants / multi-tenants
- Interface admin complète

## Architecture cible (haut niveau)
- Web (React) → API (FastAPI) → DB (PostgreSQL)
- Déploiement via Kubernetes
- Images stockées dans un registry (AWS ECR)
- Infra AWS provisionnée via Terraform (EKS + réseau + ECR)

## Environnements
- Local :
  - Docker Compose pour dev rapide
  - Kubernetes local (kind) pour apprendre les manifests et simuler “prod”
- Cloud (AWS) :
  - EKS provisionné avec Terraform
  - CI/CD : build/push vers ECR puis déploiement sur EKS

## Definition of Done (DoD)
Un incrément est “Done” si :
- Tests et lint passent
- Docker build fonctionne
- Déploiement reproductible (doc + commandes)
- Pas de secrets dans Git
- Documentation mise à jour si nécessaire

## Risques / points d’attention
- Complexité EKS/Terraform → à faire en phase 2 (après un MVP stable en local)
- Gestion des secrets (AWS/GitHub/K8s)
- Rester strict sur le périmètre MVP pour finir le projet
