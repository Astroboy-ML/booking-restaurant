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

## Contexte
Le dépôt ne définit pas encore de stratégie de gestion des secrets ni de scan automatique. Il faut sécuriser le stockage et détecter les fuites en CI.

## Objectif
Mettre en place une solution de gestion des secrets (Vault/SSM/Secrets Manager/SealedSecrets) et un scan automatique (ex: gitleaks) intégré à la CI, avec documentation d’usage.

## Hors scope
- Implémentation de nouvelles fonctionnalités applicatives dépendant des secrets.
- Refonte complète des rôles IAM (se limiter aux permissions nécessaires pour le stockage des secrets choisis).

## Scope technique
- Choix et configuration du store de secrets (SSM/Secrets Manager/SealedSecrets) avec procédure d’injection pour l’API/web.
- Ajout d’un scan de secrets dans la CI (GitHub Actions), avec configuration (ex: `.gitleaks.toml`).
- Documentation des bonnes pratiques et du flux de rotation/ajout des secrets.

## Contraintes
- Aucun secret en clair dans Git ; la CI doit échouer si un secret est détecté.
- Permissions minimales pour accéder au store (IRSA/assume role/permissions restreintes).
- Procédure compatible avec les déploiements EKS (références K8s Secrets/SSM/etc.).

## Deliverables
- Configuration du store de secrets retenu (Terraform ou documentation opérationnelle) et mode d’injection dans K8s/CI.
- Workflow CI intégrant un scan de secrets (ex: gitleaks) avec configuration commitée.
- Guide d’usage : ajout/rotation des secrets, commandes de scan local et check-list de vérification.

## Critères d’acceptation
- [ ] Le workflow CI exécute le scan de secrets et échoue en cas de fuite (outil et config dans le dépôt).
- [ ] La documentation décrit où et comment stocker/récupérer les secrets (API/web) sans texte en clair dans Git.
- [ ] Un exemple d’injection (référence à K8s Secret/SSM/Secrets Manager) est fourni pour l’API.
- [ ] Les instructions de rotation/ajout incluent les permissions requises et la commande de scan local.

## Comment tester
1) Lancer le scan local : `gitleaks detect --source . --no-git --config .gitleaks.toml` (ou outil choisi) et vérifier qu’il passe sans fuite.
2) Vérifier le workflow CI : exécuter `act -j secrets-scan` si configuré, ou déclencher le workflow sur une branche de test.
3) Tester la création d’un secret dans le store choisi (via AWS CLI ou kubectl selon option) et son injection dans un manifeste d’exemple, en s’assurant qu’aucune valeur n’est commitée.

## Plan
1) Choisir le store (SSM/Secrets Manager/SealedSecrets/Vault) et définir les permissions minimales (IRSA/role).
2) Ajouter la configuration de scan de secrets (gitleaks ou équivalent) et l’intégrer dans la CI GitHub Actions.
3) Documenter la procédure d’ajout/rotation et l’exemple d’injection dans l’API (K8s Secret/variable d’environnement).

## À contrôler
- Vérifier que les patterns de faux positifs sont gérés (ignores ciblés) sans masquer de vraies fuites.
- Confirmer que les instructions n’exposent aucun secret ni ARN critique.
- S’assurer que l’approche est compatible avec les autres tickets (déploiement EKS, build ECR).
