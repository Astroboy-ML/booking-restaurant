---
id: "2025-12-16_M20-observabilite-eks"
title: "M20 Observabilité sur EKS"
type: feature
area: devops
agents_required: [devops]
depends_on: ["2025-12-16_M19-deploy-eks"]
validated_by:
validated_at:
---

# Ticket: M20 Observabilité EKS

## But
Mettre en place la collecte des logs/metrics/traces sur EKS pour suivre l’API en production.

## Scope
- Stack observabilité (Prometheus/Grafana/CloudWatch/OTel selon choix)
- Dashboards et alertes de base
- Documentation

## Contraintes
- Coût maîtrisé (composants managés ou sizing minimal)
- Pas de secrets en clair
- Export des métriques existantes (Prometheus FastAPI) exploitable

## Deliverables
- Manifests/helm pour la stack d’observabilité
- Dashboards/alertes de base
- Documentation d’accès

## Critères d’acceptation
- [ ] Les métriques de l’API sont collectées et visibles (dashboard)
- [ ] Les logs applicatifs sont centralisés
- [ ] Une alerte basique est configurée (ex: taux d’erreur)

## Plan proposé
1) Choisir la stack (Prom/Grafana/OTel ou CloudWatch) et la déployer
2) Brancher l’API (scrape metrics, logs)
3) Créer un dashboard et une alerte minimale
