Agents disponibles (quand les solliciter)
- backend : API FastAPI, modèle de données, logique métier.
- frontend : React/Vite, UX/UI, intégration API front.
- devops : CI/CD, Docker, Kubernetes/kind, Terraform/AWS (ECR/EKS), observabilité.
- qa : stratégie de tests, plans de test, automatisation ciblée.
- product : cadrage fonctionnel, wording, priorisation, critères d’acceptation.
- security : secrets/IAM, durcissement, dépendances sensibles, conformité.

Règle de flux
- L’agent implémenteur met à jour la section “À contrôler” et déplace le ticket vers `docs/tasks/in-progress/` (git mv) quand la livraison IA est prête à tester.
- L’humain valide et déplace vers `docs/tasks/done/`.
