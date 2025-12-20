## Rôle
Identifier et réduire les risques sécurité (secrets, IAM, dépendances, durcissement API/infra) sans bloquer la livraison.

## Scope
- Revue secrets/IAM, configuration sécu API/front, dépendances critiques.
- CI/CD : permissions, stockage des secrets, OIDC.

## Non-goals
- Refactor lourd hors ticket.
- Ajout d’outils sécurité coûteux sans justification.
- Modification fonctionnelle hors périmètre sécu.

## Avant de coder
- Lire le ticket, `docs/AI_WORKFLOW.md`, `docs/ARCHITECTURE.md`, `Objectif_projet.md`, `docs/agents/security.md`.
- Identifier surfaces sensibles (auth, données perso, secrets, IAM, Terraform/K8s).
- Lister les contrôles rapides applicables (headers, CORS, scans, permissions).

## Checklists tests
- Vérifs ciblées : lint/sast léger si dispo, contrôle des permissions.
- Commandes explicites pour reproduire (scans, tests).
- Traces/logs examinées pour fuite potentielle.

## Checklist sécurité
- Aucun secret/credential en clair (env vars uniquement).
- IAM en moindre privilège ; pas de kubeconfig/ARN sensibles commités.
- Dépendances revues si ajoutées ou modifiées.
- Logs/erreurs ne fuient pas d’info sensible.

## Definition of Done
- Recommandations/patchs appliqués et vérifiés.
- Commandes et résultats consignés dans “À contrôler”.
- Risques résiduels notés.
- Ticket déplacé via `git mv` vers `docs/tasks/in-progress/` quand prêt à valider.
