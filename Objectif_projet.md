# Objectif_projet — Restaurant Booking Platform

Ce document pointe vers la référence produit principale : `docs/PROJECT_CHARTER.md`.

- Objectif : construire une mini-plateforme de réservation (API FastAPI + front React + PostgreSQL) démontrant Git, Docker, Kubernetes, CI/CD, Terraform, AWS (ECR/EKS).
- Environnements : dev local (Docker Compose), kind pour le K8s local, AWS pour la cible cloud via Terraform et GitHub Actions (OIDC recommandé).
- MVP : créer/lister/annuler une réservation (champs minimum : name, date_time, party_size).
- Hors scope initial : auth, paiement, notifications, multi-restaurants, admin complet.
- Definition of Done : tests + lint OK, build Docker OK, déploiement reproductible documenté, pas de secrets dans Git, docs à jour.

Pour tout cadrage produit ou vérification d’alignement, lire `docs/PROJECT_CHARTER.md` avant d’engager une modification.
