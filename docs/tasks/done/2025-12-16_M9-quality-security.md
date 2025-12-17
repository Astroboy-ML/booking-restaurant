# Ticket: M9  Quality & Security baseline (pre-commit + SAST + dependency + container scan)

## But
Mettre en place un socle qualité/sécurité pro (local + CI) sans refactor massif.

## Scope
- apps/api/**
- .github/workflows/**
- .github/dependabot.yml
- docs/DEV.md
- (optionnel) .pre-commit-config.yaml

## Deliverables
### Local developer experience
- pre-commit configuré
- Ruff (lint + format) sur lAPI
- Commandes documentées (install + run)

### CI
- Job lint/format (Ruff)
- Job security (Bandit + pip-audit)
- Job container scan (Trivy) sur limage API (booking-api:local ou tag CI)
- Les checks doivent tourner sur push + pull_request

### Automation deps
- Dependabot pour Python (apps/api/requirements.txt) + GitHub Actions

## Contraintes
- Pas de refactor business
- Pas dajout doutils lourds inutiles
- Doit rester reproductible sur Windows
- Les workflows existants (api-ci, kind-smoke) ne doivent pas être cassés

## Critères dacceptation
- [ ] pre-commit fonctionne en local (au moins ruff + ruff-format)
- [ ] CI exécute lint + security + scan container
- [ ] Dependabot actif et valide (YAML correct)
- [ ] docs/DEV.md explique comment lancer les checks
