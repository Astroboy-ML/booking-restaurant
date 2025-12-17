# Ticket: M8 — Observability (structured logs + metrics)

## But
Ajouter des éléments d’observabilité “pro” à l’API.

## Scope
- apps/api/
- k8s/ (si on déploie Prometheus local)
- docs/DEV.md

## Deliverables
1) Logs structurés :
- logs JSON (ou format structuré) avec au minimum : timestamp, level, path, method, status_code, duration_ms, request_id

2) Metrics :
- endpoint `/metrics` (Prometheus format)
- au minimum : count requêtes + latence (histogram) + status codes

3) k8s (optionnel dans M8, mais très cool)
- ServiceMonitor / scrape config simple (si on installe Prometheus local)

## Contraintes
- Pas de refactor massif
- Ajouter tests minimaux (au moins vérifier `/metrics` 200)
- Ne pas exposer `/metrics` publiquement en prod (noter dans doc)

## Critères d’acceptation
- [ ] `/metrics` répond 200 et contient des métriques HTTP
- [ ] Les logs incluent un request_id et le status_code
- [ ] Docs expliquent comment tester `/metrics` en local + kind
