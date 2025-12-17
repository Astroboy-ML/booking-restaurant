---
id: "2025-12-16_M8-observability"
title: "M8 Observabilite"
type: feature
area: backend
agents_required: [backend]
depends_on: []
validated_by:
validated_at:
---

## Contexte
Ajouter logs et metriques pour l'API.

## Realise
- Middleware log JSON avec request_id.
- Metrics Prometheus exposees.

## Ecarts / risques
- Ticket non template. Pas de sampling ni filtrage PII documente.

## Criteres d'acceptation
- [x] Logs structures avec request_id
- [x] Metrics disponibles (Prometheus)
- [ ] Documentation/safeguards PII
