---
id: "2025-12-16_M4-cancel-reservation"
title: "M4 Annuler une reservation"
type: feature
area: backend
agents_required: [backend]
depends_on: ["2025-12-16_M3-list-reservations"]
validated_by:
validated_at:
---

## Contexte
Permettre la suppression/annulation d'une reservation.

## Realise
- Endpoint DELETE /reservations/{id} renvoie 204 en succes, 404 sinon.
- Tests d'integration pour succes et 404.

## Ecarts / risques
- Pas de payload d'erreur structure pour les reponses 4xx.

## Criteres d'acceptation
- [x] Endpoint DELETE retourne 204 en cas de suppression
- [x] Endpoint retourne 404 si l'ID n'existe pas
- [x] Tests d'integration couvrent les deux cas
- [ ] Erreurs structurees/documentees
