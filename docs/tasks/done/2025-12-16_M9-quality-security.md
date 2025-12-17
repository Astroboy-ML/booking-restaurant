---
id: "2025-12-16_M9-quality-security"
title: "M9 Qualite et securite"
type: feature
area: security
agents_required: [security, backend]
depends_on: []
validated_by:
validated_at:
---

## Contexte
Mettre en place les workflows de qualite et securite de base.

## Realise
- Workflows Ruff, Bandit, pip-audit, Trivy en place.

## Ecarts / risques
- Makefile ne fournit pas les cibles standard (api-test/api-lint) alignement CI.
- Pas de scan de secrets (gitleaks) pour l'instant.

## Criteres d'acceptation
- [x] Lint (Ruff) et tests securite (Bandit, pip-audit) dans la CI
- [x] Scan Trivy configure
- [ ] Scan de secrets ajoute
- [ ] Cibles Makefile alignees sur la CI
