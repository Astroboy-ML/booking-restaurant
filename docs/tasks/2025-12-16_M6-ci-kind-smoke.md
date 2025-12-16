# Ticket: M6 — CI/CD with kind (build + deploy + smoke tests)

## But
Mettre en place une CI GitHub Actions qui :
- exécute les tests API
- build l’image Docker API
- crée un cluster kind
- déploie les manifests k8s (kustomize)
- vérifie /health (et idéalement POST/GET reservations)

## Scope
- .github/workflows/
- (optionnel) docs/DEV.md si on ajoute des commandes CI utiles

## Contraintes
- Pas de secrets (pas d’AWS encore)
- Reproductible et rapide (objectif < 10 min)
- On réutilise `k8s/` (kustomize) et l’image `booking-api:local`
- On garde des logs lisibles en cas d’échec

## CI attendue
### Job 1: api-tests
- setup python
- install requirements
- pytest (unit + integration “skippable” ok)

### Job 2: k8s-smoke (après api-tests)
- setup docker
- build `booking-api:local`
- create kind cluster
- kind load docker-image
- kubectl apply -k k8s
- wait pods ready
- port-forward ou curl via service (selon stratégie)
- GET /health doit retourner 200

## Critères d’acceptation
- [ ] Workflow s’exécute sur PR + push sur master/main
- [ ] api-tests passe
- [ ] k8s-smoke passe et prouve /health OK
- [ ] En cas d’échec, logs utiles (kubectl get pods, describe, logs)

## Plan proposé (à remplir par l’agent)
1)
2)
3)
