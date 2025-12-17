---
id: "2025-12-16_M16-auth-apikey"
title: "M16 Auth API key"
type: feature
area: backend
agents_required: [backend, security]
depends_on: ["2025-12-16_M0-foundation"]
validated_by:
validated_at:
---

# Ticket: M16 Auth API key

## But
Ajouter une authentification par clé API pour protéger les endpoints sensibles (exposition REST publique contrôlée).

## Scope
- API FastAPI : middleware ou dépendance de sécurité
- Configuration : clé(s) côté env/secret
- Docs : mentionner comment l’utiliser

## Contraintes
- Pas de clé en clair dans Git ; utiliser variables d’environnement ou secret store
- Refuser les requêtes sans clé ou avec clé invalide
- Ne pas casser les endpoints publics (health/metrics si souhaité)

## Deliverables
- Implémentation API key (header ou query param) avec tests
- Paramétrage via env/secret
- Documentation d’usage

## Critères d’acceptation
- [ ] Les endpoints protégés renvoient 401/403 sans clé valide
- [ ] La clé n’est pas stockée en clair dans le repo
- [ ] Les tests couvrent succès/échec d’auth

## Plan proposé
1) Ajouter une dépendance de sécurité/API key et les settings associés
2) Protéger les endpoints concernés et écrire les tests
3) Documenter l’utilisation et la configuration des clés
