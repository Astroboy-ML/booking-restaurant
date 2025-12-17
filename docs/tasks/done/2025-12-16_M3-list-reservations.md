---
id: "2025-12-16_M3-list-reservations"
title: "M3 Lister les reservations"
type: feature
area: backend
agents_required: [backend]
depends_on: ["2025-12-16_M2-postgres-persistence"]
validated_by:
validated_at:
---

## Contexte
Exposer la liste des reservations existantes.

## Realise
- Endpoint GET /reservations retournant la liste ordonnee.
- Test d'integration verifiant la presence des IDs crees.

## Ecarts / risques
- Pas de pagination ni documentation specifique.

## Criteres d'acceptation
- [x] Endpoint GET /reservations retourne les reservations ordonnees
- [x] Tests d'integration couvrent la liste
- [ ] Pagination/documentation ajoutees
