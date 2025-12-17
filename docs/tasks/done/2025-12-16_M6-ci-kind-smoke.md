---
id: "2025-12-16_M6-ci-kind-smoke"
title: "M6 CI kind smoke"
type: feature
area: devops
agents_required: [devops]
depends_on: []
validated_by:
validated_at:
---

## Contexte
Assurer un smoke test k8s via kind dans la CI.

## Realise
- Workflow kind-smoke (build image, cluster, smoke tests).

## Ecarts / risques
- Ticket initial sans template. Pas de badge/README mentionnant le workflow.

## Criteres d'acceptation
- [x] Workflow kind-smoke actif dans la CI
- [ ] Badge/mention dans README
