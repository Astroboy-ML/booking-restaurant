# Ticket: M5 — Deploy API + Postgres on kind (Kubernetes local)

## But
Déployer l’API FastAPI et PostgreSQL sur un cluster Kubernetes local (kind) avec une configuration propre.

## Scope
- k8s/
- docs/DEV.md (instructions)
- (optionnel) scripts/ ou Makefile si nécessaire

## Contraintes
- Manifests simples (pas Helm en M5)
- Utiliser ConfigMap + Secret pour la config DB (pas en dur)
- API : readinessProbe + livenessProbe
- resources.requests/limits minimal
- Reproductible depuis zéro

## Deliverables K8s
- Namespace `booking` (ou `dev`)
- Postgres :
  - Deployment + Service
  - Secret pour user/password/db
  - (Optionnel M5) PVC (sinon emptyDir acceptable pour démo)
- API :
  - Deployment + Service
  - Env `DATABASE_URL` (ou équivalent) depuis Secret/ConfigMap
  - Probes sur `/health`

## kind
- Un guide pour :
  - créer le cluster kind
  - appliquer les manifests
  - tester les endpoints

## Critères d’acceptation
- [ ] `kind create cluster` + `kubectl apply` déploient Postgres + API
- [ ] Pods Ready
- [ ] `kubectl port-forward` (ou ingress) permet d’appeler :
  - GET /health
  - POST /reservations
  - GET /reservations
- [ ] docs/DEV.md contient les commandes exactes

## Plan proposé (à remplir par l’agent)
1)
2)
3)
