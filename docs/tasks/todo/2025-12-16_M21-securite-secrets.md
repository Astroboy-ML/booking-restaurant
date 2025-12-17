---
id: "2025-12-16_M21-securite-secrets"
title: "M21 Sécurité & gestion des secrets"
type: feature
area: security
agents_required: [security, devops]
depends_on: []
validated_by:
validated_at:
---

# Ticket: M21 Sécurité & gestion des secrets

## But
Mettre en place une gestion des secrets conforme (pas de secrets en clair) et des scans de secrets dans la CI.

## Scope
- Vault/SSM/Secrets Manager ou équivalent pour stocker les secrets
- Intégration CI (scan de secrets type gitleaks)
- Documentation des bonnes pratiques

## Contraintes
- Aucune donnée sensible en clair dans GitHub
- CI doit échouer en cas de secret détecté
- Accès aux secrets via permissions minimales (principle of least privilege)

## Deliverables
- Solution de stockage de secrets définie et documentée
- Scan de secrets intégré à la CI
- Guide d’usage pour dev/ops

## Critères d’acceptation
- [ ] Aucun secret en clair dans le repo (scan de secrets passe)
- [ ] Les secrets sont stockés dans un service dédié documenté
- [ ] La CI échoue si un secret est détecté

## Plan proposé
1) Choisir/mettre en place l’outil de secrets (Vault/SSM/Secrets Manager)
2) Ajouter un scan de secrets à la CI (gitleaks ou équivalent)
3) Documenter l’usage des secrets et les permissions nécessaires
