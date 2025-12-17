---
id: "2025-12-16_M13-validation-api"
title: "M13 Validation API renforcee"
type: feature
area: backend
agents_required: [backend]
depends_on: ["2025-12-16_M4-cancel-reservation"]
validated_by:
validated_at:
---

## Contexte
Renforcer la validation et les schemas de l'API.

## Realise
- Schemas Pydantic partages request/response.

## Ecarts / risques
- Pas de validation "date dans le futur"; pas de payload d'erreurs unifie.
- AC non traites.

## Criteres d'acceptation
- [ ] Validation de date future
- [ ] Erreurs standardisees
- [ ] Schemas separes request/response si requis
