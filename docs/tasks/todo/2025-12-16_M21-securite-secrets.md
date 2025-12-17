# Ticket: M21 — Gestion des secrets & scans sécurité (CI + k8s)

## But
Sécuriser la gestion des secrets et ajouter des scans automatiques pour éviter les fuites et failles IaC/app.

## Scope
- k8s/ (secrets chiffrés : SOPS/SealedSecrets)
- .github/workflows/ (gitleaks + tfsec/checkov + éventuellement scan conteneur)
- docs/DEV.md (procédure de génération/rotation)

## Contraintes
- Aucun secret en clair dans Git ; chiffrement ou scellage obligatoire pour les manifests.
- CI doit échouer en cas de secret en clair ou de faille IaC critique.
- Compatible avec les workflows OIDC (pas de clés statiques).

## Deliverables
- Stratégie de secrets versionnés chiffrés (SOPS+age ou SealedSecrets) avec exemple pour l’API key/DB.
- Workflows CI exécutant gitleaks et tfsec/checkov (et option scan image) avec badge/rapport.
- Documentation expliquant génération de clés, ajout/rotation des secrets et usage en local/k8s/CI.

## Critères d’acceptation
- [ ] Les manifests de secrets dans Git sont chiffrés (ou scellés) uniquement.
- [ ] gitleaks et tfsec/checkov tournent en CI et échouent sur détections.
- [ ] La doc décrit clairement comment créer/mettre à jour les secrets sans les exposer.

## Plan proposé
1) Choisir l’outil de chiffrement des secrets et ajouter un exemple pour l’API/DB.
2) Ajouter les jobs CI gitleaks + tfsec/checkov (et option scan image) avec docs des variables.
3) Documenter le workflow complet de gestion des secrets (local, CI, rotation).
