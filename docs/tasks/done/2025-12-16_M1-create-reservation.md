---
id: "2025-12-16_M1-create-reservation"
title: "M1 Creation de reservation"
type: feature
area: backend
agents_required: [backend]
depends_on: ["2025-12-16_M0-foundation"]
validated_by:
validated_at:
---

## Contexte
Ajouter la creation de reservation via l'API avec validation minimale et tests.

## Realise
- Endpoint POST /reservations avec validations Pydantic (nom, date_time, party_size > 0).
- Tests unitaires pour la creation reussie.

## Ecarts / risques
- Peu de tests d'erreur (ex: date manquante, nom vide).

## Criteres d'acceptation
- [x] Endpoint POST /reservations cree une reservation valide
- [x] Validations de base appliquees sur le payload
- [x] Tests automatises couvrent le cas nominal
- [ ] Tests de validation negative (payload invalide) ajoutes
