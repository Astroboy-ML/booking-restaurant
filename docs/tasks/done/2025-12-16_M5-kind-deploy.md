---
id: "2025-12-16_M5-kind-deploy"
title: "M5 Deploiement local kind"
type: feature
area: devops
agents_required: [devops]
depends_on: []
validated_by:
validated_at:
---

## Contexte
Deployer API et Postgres sur un cluster kind pour les tests locaux.

## Realise
- Manifests Kubernetes pour namespace, Postgres, API, ingress.

## Ecarts / risques
- Ticket initial sans template, automation Makefile (kind-up/k8s-apply) non fournie.

## Criteres d'acceptation
- [x] Manifests k8s disponibles pour l'API et Postgres
- [ ] Cibles Makefile pour automatiser le deploiement kind
- [ ] Documentation d'usage
