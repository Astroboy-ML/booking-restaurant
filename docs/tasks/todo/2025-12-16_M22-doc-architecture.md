---
id: "2025-12-16_M22-doc-architecture"
title: "M22 Documentation d’architecture"
type: doc
area: product
agents_required: [product, backend, devops]
depends_on: []
validated_by:
validated_at:
---

# Ticket: M22 Documentation d’architecture

## But
Produire une documentation d’architecture claire (schémas, flux, composants) pour l’API, la base, le déploiement et les dépendances.

## Scope
- Schémas (composants, séquences)
- Cartographie des environnements (local/CI/prod)
- Doc des flux (API, DB, observabilité)

## Contraintes
- Documentation à jour par rapport aux migrations et déploiements actuels
- Partageable (format Markdown/diagrams as code si possible)
- Aucun secret dans les docs

## Deliverables
- Pages docs (Markdown) avec schémas
- Références aux pipelines, déploiements, migrations
- Plan de mise à jour continue

## Critères d’acceptation
- [ ] Les schémas couvrent API/DB/déploiement/observabilité
- [ ] Les environnements (local/CI/prod) sont décrits
- [ ] Les docs ne contiennent pas de secrets

## Plan proposé
1) Recenser les composants et flux actuels
2) Rédiger/mettre à jour les schémas et pages
3) Ajouter les références aux pipelines et migrations
