# DEV — Développement local

## Objectif
Ce document est la source de vérité pour lancer et vérifier le projet en local.

## Pré-requis
- Git
- Docker Desktop (avec support Kubernetes/Docker)
- Python 3.11+ (pour l’API) OU utilisation exclusive via Docker
- Node.js 18+ (pour le front) OU utilisation exclusive via Docker
- kubectl
- kind

> AWS/Terraform viendront plus tard (phase cloud).

## Commandes “officielles” attendues
Objectif : standardiser via Makefile (ou scripts si nécessaire sur Windows).

API
- Lint : `make api-lint`
- Tests : `make api-test`

Web
- Lint : `make web-lint`
- Tests : `make web-test`

Docker
- Build images : `make docker-build`
- Run local (compose) : `make docker-up`
- Stop : `make docker-down`

Kubernetes local (kind)
- Créer cluster : `make kind-up`
- Supprimer cluster : `make kind-down`
- Déployer manifests : `make k8s-apply`
- Détruire manifests : `make k8s-destroy`

Terraform (phase AWS)
- `make tf-fmt`
- `make tf-validate`
- `make tf-plan`
- `make tf-apply`

## Conventions
- Toute nouvelle commande de dev doit être ajoutée ici.
- Toute étape de “mise en route” doit être reproductible depuis un repo propre.

## Debug
- Logs K8s :
  - `kubectl get pods`
  - `kubectl describe pod <pod>`
  - `kubectl logs <pod>`
- Santé API :
  - endpoint `/health` (utilisé pour readiness/liveness probes)
